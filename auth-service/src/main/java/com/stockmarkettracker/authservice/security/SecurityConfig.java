package com.stockmarkettracker.authservice.security;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@RequiredArgsConstructor
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    private final JwtConverter jwtConverter;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())  // Disable CSRF if not needed
                .cors()  // Enable CORS (this refers to CorsConfigurationSource)
                .and()
                .authorizeRequests()
                .requestMatchers(HttpMethod.POST, "/auth/**").permitAll()  // Allow POST to /auth/**
                .anyRequest().authenticated()  // Require authentication for all other requests
                .and()
                .sessionManagement(sess -> sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS))  // Stateless session
                .oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt -> jwt.jwtAuthenticationConverter(jwtConverter)));  // JWT-based OAuth2 Resource Server

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration corsConfig = new CorsConfiguration();
        corsConfig.addAllowedOrigin("http://localhost:5173");  // Allow your front-end origin (update accordingly)
        corsConfig.addAllowedMethod("GET");  // Allow GET method
        corsConfig.addAllowedMethod("POST");  // Allow POST method
        corsConfig.addAllowedMethod("PUT");  // Allow PUT method
        corsConfig.addAllowedMethod("DELETE");  // Allow DELETE method
        corsConfig.addAllowedMethod("OPTIONS");  // Allow OPTIONS method for pre-flight
        corsConfig.addAllowedHeader("*");  // Allow all headers
        corsConfig.setAllowCredentials(true);  // Allow credentials (cookies, Authorization headers)

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", corsConfig);  // Apply to all paths

        return source;
    }

}
