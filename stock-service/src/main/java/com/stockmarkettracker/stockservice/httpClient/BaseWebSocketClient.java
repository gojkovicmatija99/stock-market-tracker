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

import java.net.URI;

@Component
public class BaseWebSocketClient {

    private static final Logger logger = LoggerFactory.getLogger(BaseWebSocketClient.class);

    public static final String PRICE_WEBSOCKET_URL = "/quotes/price";

    @Value("${twelvedata.websocket.base}")
    private String baseEndpoint;

    @Value("${twelvedata.api.key}")
    private String apiKey;

    private final ReactorNettyWebSocketClient reactorNettyWebSocketClient;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public BaseWebSocketClient() {
        this.reactorNettyWebSocketClient = new ReactorNettyWebSocketClient();
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
}