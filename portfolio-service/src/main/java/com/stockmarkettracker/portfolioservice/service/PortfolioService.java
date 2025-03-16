package com.stockmarkettracker.portfolioservice.service;

import com.stockmarkettracker.portfolioservice.domain.Holding;
import com.stockmarkettracker.portfolioservice.domain.Portfolio;
import com.stockmarkettracker.portfolioservice.domain.Transaction;
import com.stockmarkettracker.portfolioservice.httpClient.AuthHttpClient;
import com.stockmarkettracker.portfolioservice.httpClient.MarketHttpClient;
import com.stockmarkettracker.portfolioservice.repository.TransactionRepository;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class PortfolioService {
    @Resource
    private AuthHttpClient authHttpClient;

    @Resource
    private MarketHttpClient marketHttpClient;

    @Resource
    private TransactionRepository transactionRepository;

    public Mono<Portfolio> getPortfolio(String authHeader) {
        String userId = authHttpClient.getUserSubject(authHeader);
        Flux<Transaction> transactionFlux = transactionRepository.getTransactionsByUserId(userId);
        Flux<Holding> holdingFlux = buildHoldingsFromTransactions(authHeader, transactionFlux).onErrorResume(Mono::error);
        return Mono.zip(holdingFlux.collectList(), calculateTotalProfitAndLoss(holdingFlux))
                .map(tuple -> new Portfolio(
                        tuple.getT1(),
                        tuple.getT2()
                ));
    }

    public Flux<Holding> buildHoldingsFromTransactions(String authHeader, Flux<Transaction> transactions) {
        return transactions
                .collect(Collectors.groupingBy(Transaction::getSymbol))
                .flatMapMany(symbolMap -> Flux.fromIterable(symbolMap.entrySet())
                        .flatMap(entry -> {
                            String symbol = entry.getKey();
                            List<Transaction> symbolTransactions = entry.getValue();

                            double totalAmount = 0;
                            double totalPrice = 0;
                            for (Transaction transaction : symbolTransactions) {
                                totalAmount += transaction.getAmount();
                                totalPrice += transaction.getAmount() * transaction.getPrice();
                            }
                            double averagePrice = totalPrice / totalAmount;

                            Mono<Double> priceMono = marketHttpClient.getMarketPrice(authHeader, symbol);
                            double finalTotalAmount = totalAmount;
                            return priceMono
                                    .onErrorResume(Mono::error)
                                    .flatMap(price -> {
                                        Holding holding = new Holding(symbol, finalTotalAmount, averagePrice, price);
                                        return Mono.just(holding);
                                    });
                        }));
    }

    public Mono<Double> calculateTotalProfitAndLoss(Flux<Holding> holdings) {
        return holdings.map(Holding::getProfitLoss).reduce(0.0, Double::sum);
    }
}
