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

import java.util.List;

@Service
public class MarketService {

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
        Sinks.Many<EventPriceData> priceSink = priceWebSocketService.subscribeToPriceUpdates(symbol);
        return stockHttpClient.getRealTimePrice(symbol);
    }

    public Mono<StockProfile> getStockProfile(String symbol) {
        return stockHttpClient.getStockProfile(symbol);
    }
}
