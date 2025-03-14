package com.stockmarkettracker.portfolioservice.controller;

import com.stockmarkettracker.portfolioservice.domain.Portfolio;
import com.stockmarkettracker.portfolioservice.service.PortfolioService;
import com.stockmarkettracker.portfolioservice.service.TransactionService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/portfolio")
public class PortfolioController extends BaseController{

    @Resource
    private PortfolioService portfolioService;

    @GetMapping
    public Mono<Portfolio> getPortfolio(@RequestHeader("Authorization") String authHeader) {
        return portfolioService.getPortfolio(authHeader);
    }
}
