package com.stockmarkettracker.portfolioservice.service;

import com.stockmarkettracker.portfolioservice.domain.Transaction;
import com.stockmarkettracker.portfolioservice.httpClient.AuthHttpClient;
import com.stockmarkettracker.portfolioservice.repository.TransactionRepository;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

@Service
public class TransactionService {

    @Resource
    private AuthHttpClient authHttpClient;

    @Resource
    private TransactionRepository transactionRepository;

    public Flux<Transaction> getTransactions() {
        String userId = authHttpClient.getUserSubject();
        return transactionRepository.getTransactionByUserId(userId);
    }
}
