package com.stockmarkettracker.authservice.service;

import com.stockmarkettracker.authservice.domain.Role;
import com.stockmarkettracker.authservice.domain.User;
import org.keycloak.OAuth2Constants;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.KeycloakBuilder;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.admin.client.resource.RoleResource;
import org.keycloak.admin.client.resource.UsersResource;
import org.keycloak.representations.AccessTokenResponse;
import org.keycloak.representations.idm.CredentialRepresentation;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.ws.rs.core.Response;
import java.util.Collections;

@Service
public class KeycloakService {

    @Value("${keycloak.realm}")
    public String realm;

    @Value("${keycloak.client.id}")
    public String client;

    @Value("${keycloak.url}")
    public String serverURL;

    @Value("${keycloak.admin.client.id}")
    public String clientID;

    @Value("${keycloak.admin.credentials.secret}")
    public String clientSecret;

    public String register(User user) {
        Keycloak keycloak = KeycloakBuilder.builder()
                .realm(realm)
                .serverUrl(serverURL)
                .clientId(clientID)
                .clientSecret(clientSecret)
                .grantType(OAuth2Constants.CLIENT_CREDENTIALS)
                .build();

        CredentialRepresentation credentialRepresentation = createPasswordCredentials(user.getPassword());

        UserRepresentation kcUser = new UserRepresentation();
        kcUser.setUsername(user.getUsername());
        kcUser.setCredentials(Collections.singletonList(credentialRepresentation));
        kcUser.setEmail(user.getEmail());
        kcUser.setEnabled(true);
        kcUser.setEmailVerified(true);

        Response response = keycloak.realm(realm).users().create(kcUser);
        if (response.getStatus() != 201) {
            return response.toString();
        }

        RealmResource realmResource = keycloak.realm(realm);
        UsersResource usersResource = realmResource.users();
        UserRepresentation userRepresentation = usersResource.searchByUsername(user.getUsername(), true).get(0);

        RoleResource role = realmResource.roles().get("app_" + Role.USER);
        realmResource.users().get(userRepresentation.getId()).roles().realmLevel().add(Collections.singletonList(role.toRepresentation()));

        return "User registered successfully";
    }

    public ResponseEntity login(User user) {
        Keycloak keycloak = KeycloakBuilder.builder()
                .serverUrl(serverURL)
                .realm(realm)
                .grantType(OAuth2Constants.PASSWORD)
                .clientId(client)
                .clientSecret(clientSecret)
                .username(user.getUsername())
                .password(user.getPassword())
                .build();

        AccessTokenResponse tokenResponse = keycloak.tokenManager().getAccessToken();

        return ResponseEntity.ok(tokenResponse);
    }

    private static CredentialRepresentation createPasswordCredentials(String password) {
        CredentialRepresentation passwordCredentials = new CredentialRepresentation();
        passwordCredentials.setTemporary(false);
        passwordCredentials.setType(CredentialRepresentation.PASSWORD);
        passwordCredentials.setValue(password);
        return passwordCredentials;
    }
}
