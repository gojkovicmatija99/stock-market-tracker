package com.stockmarkettracker.portfolioservice.domain;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.lang.NonNull;

import java.util.Date;

@Document(collection = "transactions")
@Getter
@Setter
public class Transaction {
    @Id
    private String transactionId;
    @NonNull()
    private TransactionType type;
    private String userId;
    @NonNull
    private String symbol;
    private Double price;
    @NonNull
    private Double amount;
    private Date date;
}
