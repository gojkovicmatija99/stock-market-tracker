package com.stockmarkettracker.stockservice.service;

import com.stockmarkettracker.stockservice.data.RealTimePriceData;
import com.stockmarkettracker.stockservice.httpClient.StockHttpClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Slf4j
@Service
@RequiredArgsConstructor
public class WebSocketService {
    private final StockHttpClient stockHttpClient;

    public Mono<String> getFirstMessage(String symbol) {
        log.info("Getting first message for symbol: {}", symbol);
        
        return stockHttpClient.getRealTimePrice(symbol)
            .map(priceData -> {
                log.info("Received price data for {}: {}", symbol, priceData.getPrice());
                return String.format("{\"symbol\":\"%s\",\"price\":%s}", symbol, priceData.getPrice());
            })
            .doOnError(error -> log.error("Error getting first message for {}: {}", symbol, error.getMessage()));
    }
} 