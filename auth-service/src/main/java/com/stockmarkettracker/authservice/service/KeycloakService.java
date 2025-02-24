package com.stockmarkettracker.authservice.service;

import com.stockmarkettracker.authservice.domain.User;
import com.stockmarkettracker.authservice.domain.Role;
import io.jsonwebtoken.Jwts;
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
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.X509EncodedKeySpec;

import javax.ws.rs.core.Response;
import java.util.Base64;
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

    @Value("${keycloak.jwt.signing.key}")
    public String signingKey;

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

    public User getUserInfo(String token) throws NoSuchAlgorithmException, InvalidKeySpecException {
        byte[] encoded = Base64.getDecoder().decode(signingKey);

        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(encoded);
        PublicKey publicKey = keyFactory.generatePublic(keySpec);

        String subject = Jwts.parser()
                .setSigningKey(publicKey)
                .parseClaimsJws(token.split(" ")[1])
                .getBody()
                .getSubject();
        return User.builder().subject(subject).build();
    }

    private static CredentialRepresentation createPasswordCredentials(String password) {
        CredentialRepresentation passwordCredentials = new CredentialRepresentation();
        passwordCredentials.setTemporary(false);
        passwordCredentials.setType(CredentialRepresentation.PASSWORD);
        passwordCredentials.setValue(password);
        return passwordCredentials;
    }
}
