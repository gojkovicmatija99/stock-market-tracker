package com.stockmarkettracker.stockservice.httpClient;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import com.stockmarkettracker.stockservice.data.EventPriceData;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.socket.client.ReactorNettyWebSocketClient;
import org.springframework.web.reactive.socket.client.WebSocketClient;
import org.springframework.web.reactive.socket.WebSocketMessage;
import reactor.core.publisher.Sinks;

import java.net.URI;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Component
public class PriceWebSocketClient extends BaseWebSocketClient {
    private static final String PRICE_WEBSOCKET_URL = "/quotes/price";
    private final Set<String> subscribedSymbols = ConcurrentHashMap.newKeySet();
    private final ObjectMapper objectMapper = new ObjectMapper();
    private WebSocketClient webSocketClient;

    @Value("${twelvedata.api.key}")
    private String apiKey;

    @Value("${twelvedata.websocket.base}")
    private String websocketBase;

    public PriceWebSocketClient() {
        super();
    }

    @Override
    protected void handleMessage(String message) {
        try {
            log.info("Received raw message from TwelveData: {}", message);
            
            // Parse the message to check if it's a price update
            JsonNode jsonNode = objectMapper.readTree(message);
            
            // Log the message type
            if (jsonNode.has("type")) {
                log.info("Message type: {}", jsonNode.get("type").asText());
            }
            
            // Check if it's a price update message
            if (jsonNode.has("price") && jsonNode.has("symbol")) {
                String symbol = jsonNode.get("symbol").asText();
                String price = jsonNode.get("price").asText();
                
                log.info("Processing price update - Symbol: {}, Price: {}", symbol, price);
                
                // Create EventPriceData object
                EventPriceData priceData = new EventPriceData();
                priceData.setSymbol(symbol);
                priceData.setPrice(price);
                
                // Broadcast the price update
                String priceUpdateJson = objectMapper.writeValueAsString(priceData);
                broadcast(priceUpdateJson);
                log.info("Broadcasted price update for {}: {}", symbol, price);
            } else {
                log.debug("Received non-price message: {}", message);
            }
        } catch (Exception e) {
            log.error("Error handling message from TwelveData: {}", e.getMessage(), e);
        }
    }

    public void subscribe(String symbol) {
        if (subscribedSymbols.add(symbol)) {
            try {
                String subscribeMessage = objectMapper.writeValueAsString(new SubscribeMessage(symbol));
                log.info("Sending subscription message for {}: {}", symbol, subscribeMessage);
                send(subscribeMessage);
                log.info("Successfully subscribed to symbol: {}", symbol);
            } catch (Exception e) {
                log.error("Error subscribing to symbol {}: {}", symbol, e.getMessage(), e);
                subscribedSymbols.remove(symbol);
            }
        } else {
            log.info("Already subscribed to symbol: {}", symbol);
        }
    }

    public void unsubscribe(String symbol) {
        if (subscribedSymbols.remove(symbol)) {
            try {
                String unsubscribeMessage = objectMapper.writeValueAsString(new UnsubscribeMessage(symbol));
                send(unsubscribeMessage);
                log.info("Unsubscribed from symbol: {}", symbol);
            } catch (Exception e) {
                log.error("Error unsubscribing from symbol {}: {}", symbol, e.getMessage(), e);
            }
        }
    }

    @Override
    public void connect() {
        try {
            String url = websocketBase + PRICE_WEBSOCKET_URL;
            log.info("Connecting to TwelveData WebSocket at: {}", url);
            
            // Create WebSocket client if not exists
            if (webSocketClient == null) {
                webSocketClient = new ReactorNettyWebSocketClient();
                log.info("Created new WebSocket client");
            }
            
            connectToWebSocket(url);
            log.info("WebSocket connection established");

            // Send authentication message
            String authMessage = objectMapper.writeValueAsString(new AuthMessage(apiKey));
            send(authMessage);
            log.info("Sent authentication message to TwelveData");

            // Resubscribe to all symbols
            for (String symbol : subscribedSymbols) {
                subscribe(symbol);
            }
        } catch (Exception e) {
            log.error("Error connecting to TwelveData WebSocket: {}", e.getMessage(), e);
        }
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

    private static class AuthMessage {
        private final String action = "auth";
        private final String apikey;

        public AuthMessage(String apikey) {
            this.apikey = apikey;
        }

        public String getAction() {
            return action;
        }

        public String getApikey() {
            return apikey;
        }
    }

    private static class SubscribeMessage {
        private final String action = "subscribe";
        private final String[] symbols;

        public SubscribeMessage(String symbol) {
            this.symbols = new String[]{symbol};
        }

        public String getAction() {
            return action;
        }

        public String[] getSymbols() {
            return symbols;
        }
    }

    private static class UnsubscribeMessage {
        private final String action = "unsubscribe";
        private final String symbol;

        public UnsubscribeMessage(String symbol) {
            this.symbol = symbol;
        }

        public String getAction() {
            return action;
        }

        public String getSymbol() {
            return symbol;
        }
    }
}
