package com.stockmarkettracker.stockservice.httpClient;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Sinks;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Component
public class PriceWebSocketClient extends BaseWebSocketClient {
    private static final String PRICE_WEBSOCKET_URL = "/quotes/price";
    private final Set<String> subscribedSymbols = ConcurrentHashMap.newKeySet();
    private final ObjectMapper objectMapper = new ObjectMapper();

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
            log.debug("Received message from TwelveData: {}", message);
            // Parse the message and broadcast to all subscribers
            broadcast(message);
        } catch (Exception e) {
            log.error("Error handling message from TwelveData: {}", e.getMessage(), e);
        }
    }

    public void subscribe(String symbol) {
        if (subscribedSymbols.add(symbol)) {
            try {
                String subscribeMessage = objectMapper.writeValueAsString(new SubscribeMessage(symbol));
                send(subscribeMessage);
                log.info("Subscribed to symbol: {}", symbol);
            } catch (Exception e) {
                log.error("Error subscribing to symbol {}: {}", symbol, e.getMessage(), e);
                subscribedSymbols.remove(symbol);
            }
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
            connectToWebSocket(url);

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
        private final String symbol;

        public SubscribeMessage(String symbol) {
            this.symbol = symbol;
        }

        public String getAction() {
            return action;
        }

        public String getSymbol() {
            return symbol;
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
