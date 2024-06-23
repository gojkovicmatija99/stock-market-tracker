package com.stockmarkettracker.authservice.service;

import com.stockmarkettracker.authservice.data.UserData;
import com.stockmarkettracker.authservice.domain.Role;
import com.stockmarkettracker.authservice.domain.User;
import com.stockmarkettracker.authservice.exception.UserAlreadyExistAuthenticationException;
import com.stockmarkettracker.authservice.repository.UserRepository;
import jakarta.annotation.Resource;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.ReactiveUserDetailsService;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
public class UserService implements ReactiveUserDetailsService {

    @Resource
    private UserRepository userRepository;

    @Resource
    private PasswordEncoder passwordEncoder;

    @Override
    public Mono<UserDetails> findByUsername(String username) {
        return userRepository.findByUsername(username)
                .map(user -> org.springframework.security.core.userdetails.User
                        .withUsername(user.getUsername())
                        .password(user.getPassword())
                        .authorities(user.getAuthority())
                        .build());
    }

    public Mono<User> createUser(UserData user) {
        return userRepository.existsByUsername(user.getUsername())
                .flatMap(usernameExists -> {
                    if (usernameExists) {
                        return Mono.error(new UserAlreadyExistAuthenticationException("email", user.getUsername()));
                    } else {
                        return Mono.<User>empty();
                    }
                })
                .switchIfEmpty(
                        userRepository.save(User.builder()
                                .username(user.getUsername())
                                .password(passwordEncoder.encode(user.getPassword()))
                                .authority(new SimpleGrantedAuthority(Role.USER.toString()))
                                .build())
                );
    }
}
