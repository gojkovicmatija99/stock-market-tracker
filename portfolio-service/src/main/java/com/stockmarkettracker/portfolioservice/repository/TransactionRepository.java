package com.stockmarkettracker.portfolioservice.repository;

import com.stockmarkettracker.portfolioservice.domain.Transaction;
import com.stockmarkettracker.portfolioservice.domain.TransactionType;

import org.bson.types.Symbol;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface TransactionRepository extends ReactiveCrudRepository<Transaction, String> {
    Flux<Transaction> getTransactionsByUserId(String userId);
    Mono<Transaction> getTransactionByTransactionIdAndUserId(String transactionId, String userId);
    Flux<Transaction> getTransactionsBySymbolAndUserId(String symbol, String userId);
    Flux<Transaction> getTransactionByTypeAndUserId(TransactionType type, String userId);
}
