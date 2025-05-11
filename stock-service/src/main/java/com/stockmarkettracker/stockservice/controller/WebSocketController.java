package com.stockmarkettracker.stockservice.controller;

import com.stockmarkettracker.stockservice.service.WebSocketService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/ws")
@RequiredArgsConstructor
public class WebSocketController {
    private final WebSocketService webSocketService;

    @GetMapping("/first-message/{symbol}")
    public Mono<String> getFirstMessage(@PathVariable String symbol) {
        return webSocketService.getFirstMessage(symbol);
    }
} 