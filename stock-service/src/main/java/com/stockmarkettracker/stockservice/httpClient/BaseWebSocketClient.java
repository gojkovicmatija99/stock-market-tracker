package com.stockmarkettracker.stockservice.httpClient;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.socket.WebSocketMessage;
import org.springframework.web.reactive.socket.client.ReactorNettyWebSocketClient;
import reactor.core.publisher.Mono;

import java.net.URI;
import java.util.Map;

public class BaseWebSocketClient {

    public static final String PRICE_WEBSOCKET_URL = "/quotes/price";

    private final ReactorNettyWebSocketClient reactorNettyWebSocketClient;

    public BaseWebSocketClient(@Value("${twelvedata.websocket.base}") String baseEndpoint, @Value("${twelvedata.api.key}") String apiKey) {
        this.reactorNettyWebSocketClient = new ReactorNettyWebSocketClient();

        reactorNettyWebSocketClient.execute(URI.create(baseEndpoint + PRICE_WEBSOCKET_URL), session -> {
            Mono<Void> receive = session.receive()
                    .map(WebSocketMessage::toString)
                    .then();

            Mono<Void> send = session.send(Mono.just(session.textMessage("{\n" +
                            "  \"action\": \"subscribe\",\n" +
                            "  \"params\": {\n" +
                            "\t\"symbols\": \"QQQ\"\n" +
                            "  }\n" +
                            "}")))
                    .then();

            return Mono.zip(receive, send).then();
        }).subscribe();

}

}
