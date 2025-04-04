package com.stockmarkettracker.portfolioservice.domain;

import lombok.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class Portfolio {
    private String datetime;
    private List<Holding> holdingList;
    private Double totalProfitLoss;
}
