package com.stockmarkettracker.portfolioservice.domain;

import java.time.LocalDateTime;
import java.util.List;

public class Portfolio {
    private String datetime;
    private List<Holding> holdingList;
    private double totalProfitLoss;

    public Portfolio() {
    }

    public Portfolio(String datetime, List<Holding> holdingList, double totalProfitLoss) {
        this.datetime = datetime;
        this.holdingList = holdingList;
        this.totalProfitLoss = totalProfitLoss;
    }

    public String getDatetime() {
        return datetime;
    }

    public void setDatetime(String datetime) {
        this.datetime = datetime;
    }

    public List<Holding> getHoldingList() {
        return holdingList;
    }

    public void setHoldingList(List<Holding> holdingList) {
        this.holdingList = holdingList;
    }

    public double getTotalProfitLoss() {
        return totalProfitLoss;
    }

    public void setTotalProfitLoss(double totalProfitLoss) {
        this.totalProfitLoss = totalProfitLoss;
    }
}
