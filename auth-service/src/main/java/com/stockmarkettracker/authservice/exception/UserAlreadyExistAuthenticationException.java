package com.stockmarkettracker.authservice.exception;

import org.springframework.security.core.AuthenticationException;

public class UserAlreadyExistAuthenticationException extends AuthenticationException {
    public UserAlreadyExistAuthenticationException(String field, String value) {
        super(String.format("User with the value %s for field %s already exists", field, value));
    }
}
