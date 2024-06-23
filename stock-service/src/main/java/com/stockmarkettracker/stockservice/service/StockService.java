package com.stockmarkettracker.stockservice.service;

import com.stockmarkettracker.stockservice.data.RealTimePriceData;
import com.stockmarkettracker.stockservice.data.TimeSeriesData;
import com.stockmarkettracker.stockservice.domain.Interval;
import com.stockmarkettracker.stockservice.domain.StockInfo;
import com.stockmarkettracker.stockservice.httpClient.PriceWebSocketClient;
import com.stockmarkettracker.stockservice.httpClient.StockHttpClient;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;

@Service
public class StockService {

    @Resource
    private PriceWebSocketClient priceWebSocketClient;

    @Resource
    private StockHttpClient stockHttpClient;

    public Mono<List<StockInfo>> getStockInfo(String symbol) {
        return stockHttpClient.getStockInfo(symbol);
    }

    public Mono<List<StockInfo>> getEtfInfo(String symbol) {
        return stockHttpClient.getEtfInfo(symbol);
    }

    public Flux<TimeSeriesData> getTimeSeries(String symbol, Interval interval) {
        return stockHttpClient.getTimeSeries(symbol, interval);
    }

    public Flux<RealTimePriceData> getRealTimePrice(String symbol) {
        return stockHttpClient.getRealTimePrice(symbol);
    }
}
