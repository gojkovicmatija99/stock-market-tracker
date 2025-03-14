package com.stockmarkettracker.portfolioservice.domain;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@RequiredArgsConstructor
@ToString
public class Holding {
    private String symbol;
    private double positionAmount;
    private double positionPrice;
    private double profitLoss;

    public Holding(String symbol, double positionAmount, double positionPrice, double marketPrice) {
        this.symbol = symbol;
        this.positionAmount = positionAmount;
        this.positionPrice = positionPrice;
        this.profitLoss = (marketPrice - positionPrice) * positionAmount;
    }
}
