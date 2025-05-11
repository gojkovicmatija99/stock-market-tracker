package com.stockmarkettracker.stockservice.service;

import com.stockmarkettracker.stockservice.data.EventPriceData;
import com.stockmarkettracker.stockservice.data.RealTimePriceData;
import com.stockmarkettracker.stockservice.data.TimeSeriesData;
import com.stockmarkettracker.stockservice.domain.Interval;
import com.stockmarkettracker.stockservice.domain.StockInfo;
import com.stockmarkettracker.stockservice.domain.StockProfile;
import com.stockmarkettracker.stockservice.httpClient.BaseWebSocketClient;
import com.stockmarkettracker.stockservice.httpClient.PriceWebSocketClient;
import com.stockmarkettracker.stockservice.httpClient.StockHttpClient;
import jakarta.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.publisher.Sinks;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

@Service
public class MarketService {

    private static final Logger log = LoggerFactory.getLogger(MarketService.class);

    @Resource
    private BaseWebSocketClient baseWebSocketClient;

    @Resource
    private StockHttpClient stockHttpClient;

    @Autowired
    private PriceWebSocketService priceWebSocketService;

    public Mono<List<StockInfo>> getStockInfo(String symbol) {
        return stockHttpClient.getStockInfo(symbol);
    }

    public Mono<List<StockInfo>> getEtfInfo(String symbol) {
        return stockHttpClient.getEtfInfo(symbol);
    }

    public Mono<TimeSeriesData> getTimeSeries(String symbol, Interval interval) {
        return stockHttpClient.getTimeSeries(symbol, interval);
    }

    public Mono<RealTimePriceData> getRealTimePrice(String symbol) {
        // Subscribe to price updates
        Sinks.Many<EventPriceData> priceSink = priceWebSocketService.subscribeToPriceUpdates(symbol);
        
        // Set up logging for price updates
        priceSink.asFlux()
            .doOnSubscribe(sub -> log.info("Subscribed to price updates for {}", symbol))
            .doOnNext(eventPriceData -> {
                log.info("Received price update for {}: Price={}, Timestamp={}", 
                    eventPriceData.getSymbol(),
                    eventPriceData.getPrice(),
                    eventPriceData.getTimestamp());
            })
            .doOnError(error -> log.error("Error receiving price updates for {}: {}", symbol, error.getMessage()))
            .subscribe();

        // Get initial price and maintain the subscription
        return stockHttpClient.getRealTimePrice(symbol)
            .doOnSuccess(priceData -> log.info("Initial price for {}: {}", symbol, priceData.getPrice()))
            .doOnError(error -> log.error("Error getting initial price for {}: {}", symbol, error.getMessage()));
    }

    public Mono<StockProfile> getStockProfile(String symbol) {
        return stockHttpClient.getStockProfile(symbol);
    }
}
