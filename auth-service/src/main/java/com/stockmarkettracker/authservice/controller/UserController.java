package com.stockmarkettracker.authservice.controller;

import com.stockmarkettracker.authservice.data.UserData;
import com.stockmarkettracker.authservice.domain.User;
import com.stockmarkettracker.authservice.service.UserService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;


@RestController("/users")
public class UserController extends BaseController {

    @Resource
    private UserService userService;

    @PostMapping("/register")
    public Mono<User> createUser(@RequestBody UserData user) {
        return userService.createUser(user);
    }
}
