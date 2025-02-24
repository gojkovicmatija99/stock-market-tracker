package com.stockmarkettracker.portfolioservice.controller;

import com.stockmarkettracker.portfolioservice.domain.Transaction;
import com.stockmarkettracker.portfolioservice.service.TransactionService;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import reactor.core.publisher.Flux;

@Controller
@RequestMapping("/transactions")
public class TransactionController extends BaseController {

    @Resource
    private TransactionService transactionService;

    @GetMapping
    public Flux<Transaction> getTransaction() {
        return transactionService.getTransactions();
    }
}
