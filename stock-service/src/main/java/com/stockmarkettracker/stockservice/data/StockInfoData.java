package com.stockmarkettracker.stockservice.data;

import com.stockmarkettracker.stockservice.domain.StockInfo;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class StockInfoData {
    private List<StockInfo> data;
    private int count;
}
