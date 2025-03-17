package com.stockmarkettracker.portfolioservice.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import javax.naming.LimitExceededException;
import javax.ws.rs.BadRequestException;
import javax.ws.rs.NotFoundException;
import java.security.InvalidParameterException;

@ControllerAdvice
public class BaseController {

    @ExceptionHandler(InvalidParameterException.class)
    public ResponseEntity<String> handleInvalidParameterException(Exception e) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid parameter: " + e.getMessage());
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleGenericException(Exception e) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
    }

    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<String> handleNotFoundException(NotFoundException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Not found: " + e.getMessage());
    }

    @ExceptionHandler(LimitExceededException.class)
    public ResponseEntity<String> responseLimitExceededException() {
        return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).body("Too many requests, rate limit exceeded");
    }

    @ExceptionHandler(BadRequestException.class)
    public ResponseEntity<String> responseBadRequestException(Exception e) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
    }
}