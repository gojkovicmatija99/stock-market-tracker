package com.stockmarkettracker.portfolioservice.controller;

import com.stockmarkettracker.portfolioservice.domain.Transaction;
import com.stockmarkettracker.portfolioservice.service.TransactionService;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/transactions")
public class TransactionController extends BaseController {

    @Resource
    private TransactionService transactionService;

    @GetMapping
    public Flux<Transaction> getTransactions(@RequestHeader("Authorization") String authHeader) {
        return transactionService.getTransactions(authHeader);
    }

    @PostMapping
    public Mono<Transaction> saveTransaction(@RequestHeader("Authorization") String authHeader, @RequestBody @Valid Transaction transaction) {
        return transactionService.saveTransaction(authHeader, transaction);
    }

    @GetMapping("/{transactionId}")
    public Mono<Transaction> getTransaction(@RequestHeader("Authorization") String authHeader, @PathVariable String transactionId) {
        return transactionService.getTransaction(authHeader, transactionId);
    }
}