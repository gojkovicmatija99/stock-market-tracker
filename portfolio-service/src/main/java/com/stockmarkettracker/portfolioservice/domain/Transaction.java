package com.stockmarkettracker.portfolioservice.domain;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Document(collection = "transactions")
public class Transaction {
    @Id
    private String transactionId;
    private String userId;
    private String symbol;
    private double price;
    private double amount;
    private Date date;
}
