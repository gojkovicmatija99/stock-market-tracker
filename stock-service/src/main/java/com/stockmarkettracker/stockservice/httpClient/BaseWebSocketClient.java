package com.stockmarkettracker.stockservice.httpClient;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.stockmarkettracker.stockservice.data.EventPriceData;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.socket.client.ReactorNettyWebSocketClient;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.reactive.socket.WebSocketMessage;
import org.springframework.web.reactive.socket.WebSocketSession;
import org.springframework.web.reactive.socket.client.WebSocketClient;
import reactor.core.publisher.Sinks;

import java.net.URI;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Component
public abstract class BaseWebSocketClient {

    private static final Logger logger = LoggerFactory.getLogger(BaseWebSocketClient.class);

    public static final String PRICE_WEBSOCKET_URL = "/quotes/price";

    @Value("${twelvedata.websocket.base}")
    private String baseEndpoint;

    @Value("${twelvedata.api.key}")
    private String apiKey;

    protected WebSocketClient webSocketClient;
    protected Map<String, Sinks.Many<String>> messageHandlers = new ConcurrentHashMap<>();
    protected Sinks.Many<String> messageSink;

    private final ReactorNettyWebSocketClient reactorNettyWebSocketClient;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public BaseWebSocketClient() {
        this.reactorNettyWebSocketClient = new ReactorNettyWebSocketClient();
        this.messageSink = Sinks.many().multicast().onBackpressureBuffer();
    }

    public Mono<Void> getPrice(String symbols) {
        URI uri = URI.create(baseEndpoint + PRICE_WEBSOCKET_URL +"?apikey=" + apiKey);

        return reactorNettyWebSocketClient.execute(uri, session -> {
            // Prepare the subscription message as a JSON string
            String subscriptionMessage = String.format("{\n" +
                    "  \"action\": \"subscribe\",\n" +
                    "  \"params\": {\n" +
                    "\t\"symbols\": %s\n" +
                    "  }\n" +
                    "}", symbols);

            // Send the subscription message to the WebSocket server
            Mono<Void> sendMessage = session.send(Mono.just(session.textMessage(subscriptionMessage)));

            // Receive and process messages from the WebSocket
            Flux<String> receiveMessages = session.receive().skip(1)
                    .map(webSocketMessage -> {
                        try {
                            // Deserialize the incoming WebSocket message to EventPriceData
                            EventPriceData eventPriceData = objectMapper.readValue(webSocketMessage.getPayloadAsText(), EventPriceData.class);
                            // Return the relevant string (e.g., price, symbol, etc.)
                            return eventPriceData.getPrice() + " for " + eventPriceData.getSymbol();
                        } catch (Exception e) {
                            // Log the error and return a default message
                            logger.error("Error processing message: {}", e.getMessage(), e);
                            return "Error processing message";
                        }
                    });

            // Send the subscription message, then continue with receiving messages
            return sendMessage.thenMany(receiveMessages)
                    .doOnError(error -> logger.error("WebSocket error: {}", error.getMessage(), error)).then(); // Handle WebSocket errors
        });
    }

    protected void connectToWebSocket(String url) {
        log.info("Connecting to WebSocket at: {}", url);
        webSocketClient.execute(URI.create(url), session -> {
            log.info("WebSocket session established");
            
            session.receive()
                .doOnSubscribe(sub -> log.info("Subscribed to WebSocket receive"))
                .doOnNext(message -> {
                    log.info("Received WebSocket message: {}", message.getPayloadAsText());
                    handleMessage(message.getPayloadAsText());
                })
                .doOnError(error -> log.error("WebSocket receive error: {}", error.getMessage()))
                .subscribe();

            return session.send(
                messageSink.asFlux()
                    .doOnNext(msg -> log.info("Sending WebSocket message: {}", msg))
                    .map(session::textMessage)
            );
        }).subscribe(
            null,
            error -> log.error("WebSocket connection error: {}", error.getMessage())
        );
    }

    protected abstract void handleMessage(String message);
    public abstract void connect();

    protected void send(String message) {
        log.debug("Sending message: {}", message);
        messageSink.tryEmitNext(message);
    }

    protected void broadcast(String message) {
        log.debug("Broadcasting message: {}", message);
        messageHandlers.values().forEach(sink -> sink.tryEmitNext(message));
    }

    public void onMessage(String type, Sinks.Many<String> sink) {
        log.info("Registering message handler for type: {}", type);
        messageHandlers.put(type, sink);
    }

    public void removeMessageHandler(String type) {
        log.info("Removing message handler for type: {}", type);
        messageHandlers.remove(type);
    }
}