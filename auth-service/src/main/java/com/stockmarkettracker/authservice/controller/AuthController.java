package com.stockmarkettracker.authservice.controller;

import com.stockmarkettracker.authservice.domain.User;
import com.stockmarkettracker.authservice.service.KeycloakService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/auth")
public class AuthController extends BaseController {

    @Resource
    private KeycloakService keycloakService;

    @PostMapping("/register")
    public String register(@RequestBody User userRequest) {
        return keycloakService.register(userRequest);
    }

    @PostMapping("/login")
    public ResponseEntity login(@RequestBody User userRequest) {
        return keycloakService.login(userRequest);
    }
}