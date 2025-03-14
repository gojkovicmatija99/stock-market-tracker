package com.stockmarkettracker.portfolioservice.domain;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import reactor.core.publisher.Mono;

import java.util.Date;

@Document(collection = "transactions")
@Getter
@Setter
public class Transaction {
    @Id
    private String transactionId;
    private String userId;
    private String symbol;
    private String price;
    private double amount;
    private Date date;
}
