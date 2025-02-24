package com.stockmarkettracker.portfolioservice.security;

import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtClaimNames;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

import java.util.Collection;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Component
public class JwtConverter implements Converter<Jwt, Mono<AbstractAuthenticationToken>> {

    private final JwtGrantedAuthoritiesConverter jwtGrantedAuthoritiesConverter = new JwtGrantedAuthoritiesConverter();

    private final JwtConverterProperties properties;

    public JwtConverter(JwtConverterProperties properties) {
        this.properties = properties;
    }

    @Override
    public Mono<AbstractAuthenticationToken> convert(Jwt jwt) {
        // Combine authorities extracted from JWT and resource roles
        Collection<GrantedAuthority> authorities = Stream.concat(
                // Get authorities from standard JWT claims
                jwtGrantedAuthoritiesConverter.convert(jwt).stream(),
                // Get custom resource roles from the "resource_access" claim
                extractResourceRoles(jwt).stream()
        ).collect(Collectors.toSet());

        // Return the Mono of JwtAuthenticationToken with authorities and principal name
        return Mono.just(new JwtAuthenticationToken(jwt, authorities, getPrincipalClaimName(jwt)));
    }

    private String getPrincipalClaimName(Jwt jwt) {
        String claimName = properties.getPrincipalAttribute() != null ? properties.getPrincipalAttribute() : JwtClaimNames.SUB;
        return jwt.getClaim(claimName);
    }

    private Collection<GrantedAuthority> extractResourceRoles(Jwt jwt) {
        var resourceAccess = jwt.getClaimAsMap("resource_access");
        if (resourceAccess == null || resourceAccess.get(properties.getResourceId()) == null) {
            return Set.of();
        }

        var resource = (Map<String, Object>) resourceAccess.get(properties.getResourceId());
        var resourceRoles = (Collection<String>) resource.get("roles");
        return resourceRoles != null
                ? resourceRoles.stream().map(role -> new SimpleGrantedAuthority("ROLE_" + role)).collect(Collectors.toSet())
                : Set.of();
    }
}