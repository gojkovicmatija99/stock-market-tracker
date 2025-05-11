package com.stockmarkettracker.stockservice.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.stockmarkettracker.stockservice.data.EventPriceData;
import com.stockmarkettracker.stockservice.httpClient.PriceWebSocketClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Sinks;

import javax.annotation.PostConstruct;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class PriceWebSocketService {
    private final PriceWebSocketClient priceWebSocketClient;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final Map<String, Sinks.Many<EventPriceData>> priceSinks = new ConcurrentHashMap<>();

    @PostConstruct
    public void init() {
        // Connect to WebSocket when service starts
        priceWebSocketClient.connect();
        log.info("PriceWebSocketService initialized and connected to WebSocket");

        // Set up message handler for price updates
        Sinks.Many<String> messageSink = Sinks.many().multicast().onBackpressureBuffer();
        priceWebSocketClient.onMessage("price_update", messageSink);

        // Process incoming messages
        messageSink.asFlux()
            .doOnSubscribe(sub -> log.info("Subscribed to WebSocket messages"))
            .doOnNext(message -> {
                try {
                    EventPriceData priceData = objectMapper.readValue(message, EventPriceData.class);
                    String symbol = priceData.getSymbol();
                    
                    log.debug("Processing price update for symbol: {}", symbol);
                    
                    // Broadcast to all subscribers of this symbol
                    Sinks.Many<EventPriceData> symbolSink = priceSinks.get(symbol);
                    if (symbolSink != null) {
                        symbolSink.tryEmitNext(priceData);
                        log.debug("Broadcasted price update for symbol: {}", symbol);
                    } else {
                        log.warn("No subscribers found for symbol: {}", symbol);
                    }
                } catch (Exception e) {
                    log.error("Error processing price update: {}", e.getMessage(), e);
                }
            })
            .doOnError(error -> log.error("Error in WebSocket message processing: {}", error.getMessage()))
            .subscribe();
    }

    /**
     * Subscribe to real-time price updates for a symbol
     * @param symbol The stock symbol to subscribe to
     * @return A Flux of price updates for the symbol
     */
    public Sinks.Many<EventPriceData> subscribeToPriceUpdates(String symbol) {
        log.info("Subscribing to price updates for symbol: {}", symbol);
        
        // Create a new sink for this symbol if it doesn't exist
        Sinks.Many<EventPriceData> sink = priceSinks.computeIfAbsent(symbol, 
            k -> {
                log.debug("Creating new price sink for symbol: {}", k);
                return Sinks.many().multicast().onBackpressureBuffer();
            });

        // Subscribe to the symbol in the WebSocket client
        try {
            priceWebSocketClient.subscribe(symbol);
            log.info("Successfully subscribed to symbol: {}", symbol);
        } catch (Exception e) {
            log.error("Error subscribing to symbol {}: {}", symbol, e.getMessage());
            priceSinks.remove(symbol);
            throw e;
        }
        
        return sink;
    }

    /**
     * Unsubscribe from real-time price updates for a symbol
     * @param symbol The stock symbol to unsubscribe from
     */
    public void unsubscribeFromPriceUpdates(String symbol) {
        log.info("Unsubscribing from price updates for symbol: {}", symbol);
        
        // Remove the sink for this symbol
        priceSinks.remove(symbol);
        
        // Unsubscribe from the symbol in the WebSocket client
        priceWebSocketClient.unsubscribe(symbol);
    }

    /**
     * Get the current price sink for a symbol
     * @param symbol The stock symbol
     * @return The sink for price updates, or null if not subscribed
     */
    public Sinks.Many<EventPriceData> getPriceSink(String symbol) {
        return priceSinks.get(symbol);
    }
} 