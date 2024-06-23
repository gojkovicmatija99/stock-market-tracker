package com.stockmarkettracker.stockservice.data;

import com.stockmarkettracker.stockservice.domain.StockInfo;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class EventSubscriptionData {
    private String event;
    private String status;
    private List<StockInfo> success;
    private List<StockInfo> fails;
}
