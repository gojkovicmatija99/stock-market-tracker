package com.stockmarkettracker.stockservice.handler;

import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.socket.WebSocketHandler;
import org.springframework.web.reactive.socket.WebSocketMessage;
import org.springframework.web.reactive.socket.WebSocketSession;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.Duration;

@Component
public class  ReactiveWebSocketHandler implements WebSocketHandler {

    @Override
    public Mono<Void> handle(WebSocketSession session) {
        // Receiving messages
        Flux<WebSocketMessage> receive = session.receive()
                .doOnNext(message -> System.out.println("Received: " + message.getPayloadAsText()));

        // Sending messages
        Flux<WebSocketMessage> send = Flux.interval(Duration.ofSeconds(1))
                .map(sequence -> session.textMessage("Message " + sequence));

        // Return a Mono<Void> that completes when the session is closed
        return session.send(send).and(receive);
    }
}
