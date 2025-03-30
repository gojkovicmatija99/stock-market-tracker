package com.stockmarkettracker.portfolioservice.controller;

import com.stockmarkettracker.portfolioservice.domain.Interval;
import com.stockmarkettracker.portfolioservice.domain.Portfolio;
import com.stockmarkettracker.portfolioservice.service.PortfolioService;
import com.stockmarkettracker.portfolioservice.service.TransactionService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.security.InvalidParameterException;

@RestController
@RequestMapping("/portfolio")
public class PortfolioController extends BaseController{

    @Resource
    private PortfolioService portfolioService;

    @GetMapping
    public Mono<Portfolio> getPortfolio(@RequestHeader("Authorization") String authHeader) {
        return portfolioService.getPortfolio(authHeader);
    }

    @GetMapping("/history")
    public Flux<Portfolio> getPortfolioHistory(@RequestHeader("Authorization") String authHeader, @RequestParam String interval) {
        if (!Interval.isValid(interval)) {
            throw new InvalidParameterException("interval");
        }
        return portfolioService.getPortfolioHistory(authHeader, Interval.toInterval(interval));
    }
}
