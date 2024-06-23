package com.stockmarkettracker.stockservice.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class TimeSeries {
    private String datetime;
    private String open;
    private String high;
    private String low;
    private String close;
    private String volume;
}
