package com.stockmarkettracker.stockservice.data;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class EventPriceData {
    @JsonProperty("symbol")
    private String symbol;

    @JsonProperty("price")
    private String price;

    @JsonProperty("timestamp")
    private long timestamp;

    @JsonProperty("volume")
    private String volume;

    @JsonProperty("change")
    private String change;

    @JsonProperty("change_percent")
    private String changePercent;
}
