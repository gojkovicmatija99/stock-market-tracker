package com.stockmarkettracker.stockservice.httpClient;

import com.stockmarkettracker.stockservice.data.ApiResponseData;
import com.stockmarkettracker.stockservice.data.RealTimePriceData;
import com.stockmarkettracker.stockservice.data.StockInfoData;
import com.stockmarkettracker.stockservice.data.TimeSeriesData;
import com.stockmarkettracker.stockservice.domain.Interval;
import com.stockmarkettracker.stockservice.domain.StockInfo;
import com.stockmarkettracker.stockservice.domain.StockProfile;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.util.retry.Retry;

import javax.naming.LimitExceededException;
import javax.ws.rs.NotFoundException;
import java.time.Duration;
import java.util.List;

@Component
public class StockHttpClient {

    public static final String STOCK_ENDPOINT = "/stocks";

    public static final String ETF_ENDPOINT = "/etf";

    public static final String TIMESERIES_ENDPOINT = "/time_series";

    public static final String PRICE_ENDPOINT = "/price";

    public static final String PROFILE_ENDPOINT = "/profile";

    @Resource
    private BaseHttpClient baseHttpClient;

    public Mono<List<StockInfo>> getStockInfo(String symbol) {
        return baseHttpClient.getWebClient().get()
                .uri(uriBuilder -> uriBuilder.path(STOCK_ENDPOINT).queryParam("symbol", symbol).build())
                .retrieve()
                .bodyToMono(StockInfoData.class)
                .map(StockInfoData::getData);
    }

    public Mono<TimeSeriesData> getTimeSeries(String symbol, Interval interval) {
        return baseHttpClient.getWebClient().get()
                .uri(uriBuilder -> uriBuilder.path(TIMESERIES_ENDPOINT).queryParam("symbol", symbol).queryParam("interval", interval.toString()).queryParam("apikey", "2641e2a920c342399c652aec247ec866").build())
                .retrieve()
                .bodyToMono(TimeSeriesData.class)
                .flatMap(timeSeriesData -> {
                    Mono<TimeSeriesData> error = handleIfError(timeSeriesData, symbol);
                    if (error != null) {
                        return error;
                    }

                    return Mono.just(timeSeriesData);
                })
                .retryWhen(Retry.backoff(3, Duration.ofSeconds(2))
                        .filter(throwable -> throwable instanceof LimitExceededException));

    }

    public Mono<List<StockInfo>> getEtfInfo(String symbol) {
        return baseHttpClient.getWebClient().get()
                .uri(uriBuilder -> uriBuilder.path(ETF_ENDPOINT).queryParam("symbol", symbol).build())
                .retrieve()
                .bodyToMono(StockInfoData.class)
                .map(StockInfoData::getData);
    }

    public Mono<RealTimePriceData> getRealTimePrice(String symbol) {
        return baseHttpClient.getWebClient().get()
                .uri(uriBuilder -> uriBuilder.path(PRICE_ENDPOINT)
                        .queryParam("symbol", symbol)
                        .queryParam("apikey", "2641e2a920c342399c652aec247ec866")
                        .build())
                .retrieve()
                .bodyToMono(RealTimePriceData.class)
                .flatMap(priceData -> {
                   Mono<RealTimePriceData> error = handleIfError(priceData, symbol);
                   if (error != null) {
                       return error;
                   }

                    return Mono.just(RealTimePriceData.builder().price(priceData.getPrice()).build());
                })
                .retryWhen(Retry.backoff(3, Duration.ofSeconds(2))
                        .filter(throwable -> throwable instanceof LimitExceededException));
    }

    public Mono<StockProfile> getStockProfile(String symbol) {
        return baseHttpClient.getWebClient().get()
                .uri(uriBuilder -> uriBuilder.path(PROFILE_ENDPOINT)
                        .queryParam("symbol", symbol)
                        .queryParam("apikey", "2641e2a920c342399c652aec247ec866")
                        .build())
                .retrieve()
                .bodyToMono(StockProfile.class)
                .flatMap(profile -> {
                    Mono<StockProfile> error = handleIfError(profile, symbol);
                    if (error != null) {
                        return error;
                    }
                    return Mono.just(profile);
                })
                .retryWhen(Retry.backoff(3, Duration.ofSeconds(2))
                        .filter(throwable -> throwable instanceof LimitExceededException));
    }

    private <T> Mono<T> handleIfError(ApiResponseData apiResponseData, String symbol){
        if (apiResponseData.getStatus() == null || !apiResponseData.getStatus().equals("error")) {
            return null;
        }

        if (apiResponseData.getCode() == 429) {
            return Mono.error(new LimitExceededException());
        }

        if (apiResponseData.getCode() == 404) {
            return Mono.error(new NotFoundException(symbol));
        }

        return Mono.error(new Exception(apiResponseData.getMessage()));
    }
}