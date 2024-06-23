package com.stockmarkettracker.stockservice.controller;

import com.stockmarkettracker.stockservice.data.RealTimePriceData;
import com.stockmarkettracker.stockservice.data.TimeSeriesData;
import com.stockmarkettracker.stockservice.domain.Interval;
import com.stockmarkettracker.stockservice.domain.StockInfo;
import com.stockmarkettracker.stockservice.service.StockService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.security.InvalidParameterException;
import java.util.List;

@RestController
public class StockController {

    @Resource
    private StockService stockService;

    @GetMapping("/stocks/{symbol}")
    public Mono<List<StockInfo>> getStockInfo(@PathVariable String symbol) {
        return stockService.getStockInfo(symbol);
    }

    @GetMapping("/etfs/{symbol}")
    public Mono<List<StockInfo>> getEtfInfo(@PathVariable String symbol) {
        return stockService.getEtfInfo(symbol);
    }

    @GetMapping("/time-series/{symbol}")
    public Flux<TimeSeriesData> getTimeSeries(@PathVariable String symbol, @RequestParam String interval) {
        if (!Interval.isValid(interval)) {
            throw new InvalidParameterException("interval");
        }
        return stockService.getTimeSeries(symbol, Interval.toInterval(interval));
    }

    @GetMapping("/prices/{symbol}")
    public Flux<RealTimePriceData> getRealTimePrice(@PathVariable String symbol) {
        return stockService.getRealTimePrice(symbol);
    }
}