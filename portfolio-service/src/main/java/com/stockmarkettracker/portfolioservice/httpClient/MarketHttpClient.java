package com.stockmarkettracker.portfolioservice.httpClient;

import com.fasterxml.jackson.databind.JsonNode;
import com.stockmarkettracker.portfolioservice.data.RealTimePriceData;
import com.stockmarkettracker.portfolioservice.domain.User;
import jakarta.annotation.Resource;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import reactor.core.publisher.Mono;
import reactor.util.retry.Retry;

import javax.naming.LimitExceededException;
import javax.ws.rs.NotFoundException;
import java.time.Duration;

@Component
public class MarketHttpClient {

    @Resource
    private DiscoveryClient discoveryClient;

    private final WebClient webClient;

    public MarketHttpClient(WebClient.Builder webClientBuilder) {
        this.webClient = webClientBuilder.build();
    }

    public Mono<Double> getMarketPrice(String authToken, String symbol) {
        var serviceInstance = discoveryClient.getInstances("stock-service")
                .stream()
                .findFirst()
                .orElseThrow(() -> new RuntimeException("No instances of stock-service found"));

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", authToken);

        return webClient.get()
                .uri(serviceInstance.getUri() + "/market/prices/" + symbol)
                .headers(httpHeaders -> httpHeaders.addAll(headers))
                .retrieve()
                .onStatus(status -> status.equals(HttpStatusCode.valueOf(429)), response -> Mono.error(new LimitExceededException()))
                .onStatus(status -> status.equals(HttpStatusCode.valueOf(404)), response -> Mono.error(new NotFoundException(symbol)))
                .onStatus(status -> status.equals(HttpStatusCode.valueOf(500)), response -> Mono.error(new Exception(response.toString())))
                .bodyToMono(RealTimePriceData.class)
                .map(RealTimePriceData::getPrice);
    }

}
