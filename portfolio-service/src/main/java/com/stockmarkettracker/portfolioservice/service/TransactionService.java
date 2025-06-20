package com.stockmarkettracker.portfolioservice.service;

import com.stockmarkettracker.portfolioservice.domain.Transaction;
import com.stockmarkettracker.portfolioservice.httpClient.AuthHttpClient;
import com.stockmarkettracker.portfolioservice.httpClient.MarketHttpClient;
import com.stockmarkettracker.portfolioservice.repository.TransactionCustomRepository;
import com.stockmarkettracker.portfolioservice.repository.TransactionRepository;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.Date;

@Service
public class TransactionService {

    @Resource
    private AuthHttpClient authHttpClient;

    @Resource
    private MarketHttpClient marketHttpClient;

    @Resource
    private TransactionRepository transactionRepository;

    public Flux<Transaction> getTransactions(String authHeader) {
        String userId = authHttpClient.getUserSubject(authHeader);
        return transactionRepository.getTransactionsByUserId(userId);
    }

    public Flux<Transaction> getTransactionsBySymbol(String authHeader, String symbol) {
        String userId = authHttpClient.getUserSubject(authHeader);
        return transactionRepository.getTransactionsBySymbolAndUserId(symbol, userId);
    }

    public Mono<Transaction> getTransaction(String authHeader, String transactionId) {
        String userId = authHttpClient.getUserSubject(authHeader);
        return transactionRepository.getTransactionByTransactionIdAndUserId(transactionId, userId);
    }

    public Mono<Transaction> saveTransaction(String authHeader, Transaction transaction) {
        String userId = authHttpClient.getUserSubject(authHeader);
        transaction.setSymbol(transaction.getSymbol().toUpperCase());

        return marketHttpClient.getMarketPrice(authHeader, transaction.getSymbol())
                .onErrorResume(Mono::error).flatMap(price -> {
                    transaction.setUserId(userId);
                    transaction.setDate(new Date());
                    transaction.setPrice(price);

                    return transactionRepository.save(transaction);
                });
    }
}