package com.stockmarkettracker.portfolioservice.service;

import com.stockmarkettracker.portfolioservice.domain.Transaction;
import com.stockmarkettracker.portfolioservice.domain.TransactionType;
import com.stockmarkettracker.portfolioservice.httpClient.AuthHttpClient;
import com.stockmarkettracker.portfolioservice.httpClient.MarketHttpClient;
import com.stockmarkettracker.portfolioservice.repository.TransactionRepository;
import io.jsonwebtoken.lang.Strings;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.math.MathFlux;

import javax.ws.rs.BadRequestException;
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
//        Flux<Double> buyTransactionFlux = transactionRepository .getTransactionByTypeAndUserId(TransactionType.BUY, userId)
//                                                                .map(Transaction::getAmount);
//        return Mono.zip(MathFlux.sumInt(buyTransactionFlux), priceMono).flatMap(tuple -> {
//            Integer sum = tuple.getT1();
//            Double price = tuple.getT2();
//
//            if (sum < transaction.getAmount() && transaction.getType().equals(TransactionType.SELL)) {
//                return Mono.error(new BadRequestException("Not enough " + transaction.getSymbol() + " to sell"));
//            }
//
//            transaction.setUserId(userId);
//            transaction.setDate(new Date());
//            transaction.setPrice(price);
//
//            return transactionRepository.save(transaction);
//        });


    }
}