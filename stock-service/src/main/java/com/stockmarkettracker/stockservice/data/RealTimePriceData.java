package com.stockmarkettracker.stockservice.data;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class RealTimePriceData extends ApiResponseData {
    private Double price;
}
