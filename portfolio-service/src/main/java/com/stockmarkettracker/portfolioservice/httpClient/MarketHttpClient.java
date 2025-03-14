package com.stockmarkettracker.portfolioservice.httpClient;

import com.stockmarkettracker.portfolioservice.data.RealTimePriceData;
import com.stockmarkettracker.portfolioservice.domain.User;
import jakarta.annotation.Resource;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Component
public class MarketHttpClient {

    @Resource
    private DiscoveryClient discoveryClient;

    private final WebClient webClient;

    public MarketHttpClient(WebClient.Builder webClientBuilder) {
        this.webClient = webClientBuilder.build();
    }

    public Mono<String> getMarketPrice(String authToken, String symbol) {
        return Mono.defer(() -> {
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
                    .bodyToMono(RealTimePriceData.class)
                    .map(priceData -> priceData.getPrice());
        });
    }
}
