package com.stockmarkettracker.portfolioservice.domain;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Document(collection = "transactions")
@Getter
@Setter
public class Transaction {
    @Id
    private String transactionId;
    @NotNull
    private TransactionType type;
    private String userId;
    @NotNull
    @NotBlank
    private String symbol;
    private Double price;
    @NotNull
    private Double amount;
    private Date date;
}
