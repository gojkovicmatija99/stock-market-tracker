package com.stockmarkettracker.stockservice.data;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class EventPriceData {
    public String event;
    public String symbol;
    public String currency;
    public String exchange;
    public double price;
    public long timestamp;
}
