package com.stockmarkettracker.stockservice.handler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.stockmarkettracker.stockservice.data.EventPriceData;
import com.stockmarkettracker.stockservice.service.PriceWebSocketService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.socket.WebSocketHandler;
import org.springframework.web.reactive.socket.WebSocketMessage;
import org.springframework.web.reactive.socket.WebSocketSession;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Component
@RequiredArgsConstructor
public class ReactiveWebSocketHandler implements WebSocketHandler {
    private final PriceWebSocketService priceWebSocketService;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final Map<String, WebSocketSession> sessions = new ConcurrentHashMap<>();

    @Override
    public Mono<Void> handle(WebSocketSession session) {
        String sessionId = session.getId();
        sessions.put(sessionId, session);
        log.info("New WebSocket connection established: {}", sessionId);

        // Handle incoming messages (subscription requests)
        Mono<Void> input = session.receive()
                .doOnSubscribe(sub -> log.info("Subscribed to receive messages for session: {}", sessionId))
                .doOnNext(message -> {
                    try {
                        String symbol = message.getPayloadAsText();
                        log.info("Received subscription request for symbol: {} from session: {}", symbol, sessionId);
                        
                        // Subscribe to price updates for this symbol
                        priceWebSocketService.subscribeToPriceUpdates(symbol)
                            .asFlux()
                            .doOnNext(priceData -> {
                                try {
                                    String priceUpdate = objectMapper.writeValueAsString(priceData);
                                    session.send(Mono.just(session.textMessage(priceUpdate)))
                                        .subscribe(
                                            null,
                                            error -> log.error("Error sending price update to session {}: {}", sessionId, error.getMessage())
                                        );
                                } catch (Exception e) {
                                    log.error("Error serializing price update for session {}: {}", sessionId, e.getMessage());
                                }
                            })
                            .doOnError(error -> log.error("Error in price update stream for session {}: {}", sessionId, error.getMessage()))
                            .subscribe();
                    } catch (Exception e) {
                        log.error("Error processing message from session {}: {}", sessionId, e.getMessage());
                    }
                })
                .doOnError(error -> log.error("Error in WebSocket receive for session {}: {}", sessionId, error.getMessage()))
                .then();

        // Handle session closure
        Mono<Void> output = session.send(Flux.never())
                .doOnTerminate(() -> {
                    log.info("WebSocket session closed: {}", sessionId);
                    sessions.remove(sessionId);
                });

        return Mono.zip(input, output).then();
    }
}
