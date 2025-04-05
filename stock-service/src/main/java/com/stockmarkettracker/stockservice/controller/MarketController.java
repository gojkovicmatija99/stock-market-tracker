package com.stockmarkettracker.stockservice.controller;

import com.stockmarkettracker.stockservice.data.RealTimePriceData;
import com.stockmarkettracker.stockservice.data.TimeSeriesData;
import com.stockmarkettracker.stockservice.domain.Interval;
import com.stockmarkettracker.stockservice.domain.StockInfo;
import com.stockmarkettracker.stockservice.service.MarketService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.security.InvalidParameterException;
import java.util.List;

@RestController
@RequestMapping("/market")
public class MarketController {

    @Resource
    private MarketService stockService;

    @GetMapping("/stocks/{symbol}")
    public Mono<List<StockInfo>> getStockInfo(@PathVariable String symbol) {
        return stockService.getStockInfo(symbol);
    }

    @GetMapping("/etfs/{symbol}")
    public Mono<List<StockInfo>> getEtfInfo(@PathVariable String symbol) {
        return stockService.getEtfInfo(symbol);
    }

    @GetMapping("/time-series/{symbol}")
    public Mono<TimeSeriesData> getTimeSeries(@PathVariable String symbol, @RequestParam String interval) {
        if (!Interval.isValid(interval)) {
            throw new InvalidParameterException("interval");
        }
        return stockService.getTimeSeries(symbol, Interval.toInterval(interval));
    }

    @GetMapping("/prices/{symbol}")
    public Mono<RealTimePriceData> getRealTimePrice(@PathVariable String symbol) {
        return stockService.getRealTimePrice(symbol);
    }
}