package com.stockmarkettracker.stockservice.data;

import com.stockmarkettracker.stockservice.domain.StockInfo;
import com.stockmarkettracker.stockservice.domain.TimeSeries;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class TimeSeriesData extends ApiResponseData{
    private StockInfo meta;
    private List<TimeSeries> values;
}
