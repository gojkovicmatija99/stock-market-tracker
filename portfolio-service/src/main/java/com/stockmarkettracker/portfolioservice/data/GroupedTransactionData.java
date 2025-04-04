package com.stockmarkettracker.portfolioservice.data;

import com.stockmarkettracker.portfolioservice.domain.Transaction;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class GroupedTransactionData {
    private String symbol;
    private List<Transaction> transactions;
}
