package com.stockmarkettracker.portfolioservice.data;

import com.stockmarkettracker.portfolioservice.domain.StockInfo;
import com.stockmarkettracker.portfolioservice.domain.TimeSeries;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class TimeSeriesData {
    private StockInfo meta;
    private List<TimeSeries> values;
}
