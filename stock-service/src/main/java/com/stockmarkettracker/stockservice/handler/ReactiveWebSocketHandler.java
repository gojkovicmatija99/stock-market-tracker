package com.stockmarkettracker.stockservice.handler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.stockmarkettracker.stockservice.data.RealTimePriceData;
import com.stockmarkettracker.stockservice.service.MarketService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.socket.WebSocketHandler;
import org.springframework.web.reactive.socket.WebSocketMessage;
import org.springframework.web.reactive.socket.WebSocketSession;
import reactor.core.publisher.Mono;
import reactor.core.publisher.Flux;
import java.time.Duration;

@Slf4j
@Component
@RequiredArgsConstructor
public class ReactiveWebSocketHandler implements WebSocketHandler {
    private final MarketService marketService;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public Mono<Void> handle(WebSocketSession session) {
        return session.receive()
                .doOnSubscribe(sub -> log.info("New WebSocket connection established: {}", session.getId()))
                .flatMap(message -> {
                    String symbol = message.getPayloadAsText();
                    log.info("Received subscription request for symbol: {}", symbol);
                    
                    // Create a flux that emits price updates every 5 seconds
                    return Flux.interval(Duration.ofSeconds(5))
                            .flatMap(tick -> marketService.getRealTimePrice(symbol))
                            .flatMap(priceData -> {
                                try {
                                    String priceUpdate = objectMapper.writeValueAsString(priceData);
                                    return session.send(Mono.just(session.textMessage(priceUpdate)));
                                } catch (Exception e) {
                                    log.error("Error serializing price update: {}", e.getMessage());
                                    return Mono.empty();
                                }
                            })
                            .doOnError(error -> log.error("Error in price update stream: {}", error.getMessage()))
                            .then();
                })
                .doOnError(error -> log.error("WebSocket error: {}", error.getMessage()))
                .then();
    }
}
