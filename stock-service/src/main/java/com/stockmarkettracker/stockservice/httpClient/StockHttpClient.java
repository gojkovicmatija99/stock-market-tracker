package com.stockmarkettracker.stockservice.httpClient;

import com.stockmarkettracker.stockservice.data.RealTimePriceData;
import com.stockmarkettracker.stockservice.data.StockInfoData;
import com.stockmarkettracker.stockservice.data.TimeSeriesData;
import com.stockmarkettracker.stockservice.domain.Interval;
import com.stockmarkettracker.stockservice.domain.StockInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;

@Component
public class StockHttpClient {

    public static final String STOCK_ENDPOINT = "/stocks";

    public static final String ETF_ENDPOINT = "/etf";

    public static final String TIMESERIES_ENDPOINT = "/time_series";

    public static final String PRICE_ENDPOINT = "/price";

    @Resource
    private BaseHttpClient baseHttpClient;

    public Mono<List<StockInfo>> getStockInfo(String symbol) {
        return baseHttpClient.getWebClient().get()
                .uri(uriBuilder -> uriBuilder.path(STOCK_ENDPOINT).queryParam("symbol", symbol).build())
                .retrieve()
                .bodyToMono(StockInfoData.class)
                .map(StockInfoData::getData);
    }

    public Flux<TimeSeriesData> getTimeSeries(String symbol, Interval interval) {
        return baseHttpClient.getWebClient().get()
                .uri(uriBuilder -> uriBuilder.path(TIMESERIES_ENDPOINT).queryParam("symbol", symbol).queryParam("interval", interval.toString()).queryParam("apikey", "2641e2a920c342399c652aec247ec866").build())
                .retrieve()
                .bodyToFlux(TimeSeriesData.class);
    }

    public Mono<List<StockInfo>> getEtfInfo(String symbol) {
        return baseHttpClient.getWebClient().get()
                .uri(uriBuilder -> uriBuilder.path(ETF_ENDPOINT).queryParam("symbol", symbol).build())
                .retrieve()
                .bodyToMono(StockInfoData.class)
                .map(StockInfoData::getData);
    }

    public Flux<RealTimePriceData> getRealTimePrice(String symbol) {
        return baseHttpClient.getWebClient().get()
                .uri(uriBuilder -> uriBuilder.path(PRICE_ENDPOINT).queryParam("symbol", symbol).build())
                .retrieve()
                .bodyToFlux(RealTimePriceData.class);
    }
}