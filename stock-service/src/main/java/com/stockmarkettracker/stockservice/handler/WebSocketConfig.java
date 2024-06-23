package com.stockmarkettracker.stockservice.handler;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.HandlerMapping;
import org.springframework.web.reactive.config.EnableWebFlux;
import org.springframework.web.reactive.handler.SimpleUrlHandlerMapping;
import org.springframework.web.reactive.socket.WebSocketHandler;

import java.util.Map;

@Configuration
@EnableWebFlux
public class WebSocketConfig {

    @Bean
    public HandlerMapping webSocketMapping(ReactiveWebSocketHandler webSocketHandler) {
        return new SimpleUrlHandlerMapping(Map.of("/ws", webSocketHandler), -1);
    }

    @Bean
    public WebSocketHandler webSocketHandler() {
        return new ReactiveWebSocketHandler();
    }
}
