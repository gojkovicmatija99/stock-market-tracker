//package com.stockmarkettracker.authservice.config;
//
//import com.stockmarkettracker.authservice.domain.Role;
//import com.stockmarkettracker.authservice.domain.User;
//import com.stockmarkettracker.authservice.repository.UserRepository;
//import jakarta.annotation.Resource;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.boot.context.event.ApplicationStartedEvent;
//import org.springframework.context.ApplicationListener;
//import org.springframework.security.core.authority.SimpleGrantedAuthority;
//import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.stereotype.Component;
//import reactor.core.publisher.Mono;
//
//@Component
//@RequiredArgsConstructor
//@Slf4j
//public class InitialDataSeeder implements ApplicationListener<ApplicationStartedEvent> {
//    private final UserRepository userRepository;
//
//    @Resource
//    private final PasswordEncoder passwordEncoder;
//
//    @Override
//    public void onApplicationEvent(ApplicationStartedEvent event) {
//        userRepository.findByUsername("admin")
//                .switchIfEmpty(createAdminUser())
//                .subscribe();
//    }
//
//    private Mono<User> createAdminUser() {
//        return userRepository
//                .save(User
//                        .builder()
//                        .username("admin")
//                        .password(passwordEncoder.encode("admin"))
//                        .authority(new SimpleGrantedAuthority(Role.ADMIN.toString()))
//                        .build())
//                .doOnNext(user -> log.info("Admin user created successfully"));
//    }
//}
