package com.stockmarkettracker.authservice.domain;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class User {
    private String subject;
    private String email;
    private String username;
    private String password;
}
