package com.stockmarkettracker.authservice.controller;

import com.stockmarkettracker.authservice.domain.User;
import com.stockmarkettracker.authservice.service.KeycloakService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/api")
public class AuthController extends BaseController {

    @Resource
    private KeycloakService keycloakService;

    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody User userRequest) {
        keycloakService.registerUser(userRequest.getUsername(), userRequest.getPassword(), userRequest.getEmail());
        return ResponseEntity.ok("User registered successfully");

    }
}