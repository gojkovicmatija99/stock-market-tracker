package com.stockmarkettracker.portfolioservice.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Portfolio {
    private String datetime;
    private List<Holding> holdingList;
    private double totalPositionPrice;
    private double totalProfitLoss;
}
