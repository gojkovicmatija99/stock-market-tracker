package com.stockmarkettracker.authservice.domain;

import lombok.Builder;
import lombok.Getter;
import org.springframework.data.mongodb.core.mapping.Document;

import org.springframework.data.annotation.Id;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

@Getter
@Builder
@Document(collection = "users")
public class User {

    @Id
    private String id;
    private String username;
    private String password;
    private GrantedAuthority authority;
}
