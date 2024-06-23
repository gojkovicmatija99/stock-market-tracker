package com.stockmarkettracker.authservice.controller;

import com.stockmarkettracker.authservice.exception.UserAlreadyExistAuthenticationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.security.InvalidParameterException;

@ControllerAdvice
public class BaseController {

    @ExceptionHandler(InvalidParameterException.class)
    public ResponseEntity<String> responseInvalidParameterException(Exception e) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid parameter: " + e.getMessage());
    }

    @ExceptionHandler(UserAlreadyExistAuthenticationException.class)
    public ResponseEntity<String> responseUserAlreadyExistAuthenticationException(Exception e) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
    }
}
