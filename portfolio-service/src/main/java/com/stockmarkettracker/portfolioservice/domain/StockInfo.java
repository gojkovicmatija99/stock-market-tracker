package com.stockmarkettracker.portfolioservice.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class StockInfo {
    private String symbol;
    private String name;
    private String exchange;
    private String mic_code;
    private String country;
    private String type;

    @Override
    public int hashCode() {
        return symbol.hashCode();
    }
}
