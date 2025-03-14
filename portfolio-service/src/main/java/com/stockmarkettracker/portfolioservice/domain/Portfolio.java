package com.stockmarkettracker.portfolioservice.domain;

import lombok.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@ToString
public class Portfolio {
    private List<Holding> holdingList;
    private Double totalProfitLoss;
}
