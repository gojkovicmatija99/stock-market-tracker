package com.stockmarkettracker.stockservice.httpClient;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.Map;

@Component
@Getter
public class BaseHttpClient {

    private final WebClient webClient;

    @Autowired
    public BaseHttpClient(WebClient.Builder webClientBuilder, @Value("${twelvedata.api.base}") String baseEndpoint, @Value("${twelvedata.api.key}") String apiKey) {
        this.webClient = webClientBuilder.baseUrl(baseEndpoint).defaultUriVariables(Map.of("apikey", apiKey)).build();
    }
}
