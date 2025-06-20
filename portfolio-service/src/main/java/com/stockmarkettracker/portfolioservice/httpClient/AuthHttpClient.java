package com.stockmarkettracker.portfolioservice.httpClient;

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

@Component
public class AuthHttpClient {

    @Resource
    private DiscoveryClient discoveryClient;

    @Resource
    private final RestTemplate restTemplate;

    public AuthHttpClient(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public String getUserSubject(String authToken) throws HttpClientErrorException {
        // Get the service instance for the auth-service
        ServiceInstance serviceInstance = discoveryClient.getInstances("auth-service").get(0);

        // Create the HttpHeaders and add the Authorization header with the Bearer token
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", authToken);

        // Create an HttpEntity with the headers
        HttpEntity<String> entity = new HttpEntity<>(headers);

        // Make the GET request with the Authorization header
        User userInfo = restTemplate.exchange(
                serviceInstance.getUri() + "/auth/userinfo", // URL
                HttpMethod.GET,                         // HTTP method
                entity,                                 // HTTP request entity (with headers)
                User.class                               // Response type
        ).getBody();

        return userInfo.getSubject(); // Return the subject from the response
    }
}
