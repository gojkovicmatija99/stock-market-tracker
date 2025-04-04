package com.stockmarkettracker.portfolioservice.service;

import com.stockmarkettracker.portfolioservice.data.GroupedTransactionData;
import com.stockmarkettracker.portfolioservice.data.TimeSeriesData;
import com.stockmarkettracker.portfolioservice.domain.*;
import com.stockmarkettracker.portfolioservice.httpClient.AuthHttpClient;
import com.stockmarkettracker.portfolioservice.httpClient.MarketHttpClient;
import com.stockmarkettracker.portfolioservice.repository.TransactionCustomRepository;
import com.stockmarkettracker.portfolioservice.repository.TransactionRepository;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class PortfolioService {

    public static final int MAX_HISTORY_POINTS = 5;

    @Resource
    private AuthHttpClient authHttpClient;

    @Resource
    private MarketHttpClient marketHttpClient;

    @Resource
    private TransactionRepository transactionRepository;

    @Resource
    private TransactionCustomRepository transactionCustomRepository;

    public Mono<Portfolio> getPortfolio(String authHeader) {
        String userId = authHttpClient.getUserSubject(authHeader);
        Flux<GroupedTransactionData> groupedTransactionFlux = transactionCustomRepository.getTransactionsGroupedBySymbol(userId);
        Flux<Holding> holdingFlux = buildHoldingsFromTransactions(authHeader, groupedTransactionFlux).onErrorResume(Mono::error);
        return Mono.zip(holdingFlux.collectList(), calculateTotalProfitAndLoss(holdingFlux))
                .map(tuple -> new Portfolio(
                        null,
                        tuple.getT1(),
                        tuple.getT2()
                ));
    }

    private Flux<Holding> buildHoldingsFromTransactions(String authHeader, Flux<GroupedTransactionData> groupedTransactionFlux) {
        return groupedTransactionFlux
                .flatMap(groupedTransaction -> {
                    String symbol = groupedTransaction.getSymbol();
                    List<Transaction> transactions = groupedTransaction.getTransactions();

                    double totalAmount = transactions.stream()
                            .mapToDouble(t -> t.getType() == TransactionType.BUY ? t.getAmount() : -t.getAmount())
                            .sum();

                    double totalPrice = transactions.stream()
                            .mapToDouble(t -> t.getType() == TransactionType.BUY
                                    ? t.getAmount() * t.getPrice()
                                    : -t.getAmount() * t.getPrice())
                            .sum();

                    double averagePrice = totalAmount != 0 ? totalPrice / totalAmount : 0;

                    Mono<Double> priceMono = marketHttpClient.getMarketPrice(authHeader, symbol);
                    return priceMono
                            .onErrorResume(Mono::error)
                            .flatMap(price -> {
                                Holding holding = new Holding(symbol, totalAmount, averagePrice, price);
                                return Mono.just(holding);
                            });
                });
    }

    public Flux<Portfolio> getPortfolioHistory(String authHeader, Interval interval) {
        String userId = authHttpClient.getUserSubject(authHeader);
        Flux<Transaction> transactionFlux = transactionRepository.getTransactionsByUserId(userId);
        Mono<Map<String, TimeSeriesData>> timeSeriesDataMono = getTimeSeries(authHeader, interval);

        return Mono.zip(transactionFlux.collectList(), timeSeriesDataMono)
                .flatMapMany(tuple -> {
                    List<Transaction> transactions = tuple.getT1();
                    Map<String, TimeSeriesData> timeSeriesDataMap = tuple.getT2();

                    Map<String, List<Transaction>> groupedBySymbol = groupTransactionsBySymbol(transactions);

                    List<Portfolio> portfolioList = new ArrayList<>();

                    for (int i = 0; i < MAX_HISTORY_POINTS; i++) {
                        Portfolio portfolio = new Portfolio();
                        Map<String, Holding> holdingsMap = new HashMap<>();
                        for (Map.Entry<String, TimeSeriesData> entry : timeSeriesDataMap.entrySet()) {
                            String symbol = entry.getKey();

                            if (groupedBySymbol.containsKey(symbol)) {
                                double totalAmount = 0;
                                double totalPrice = 0;
                                for (Transaction transaction : groupedBySymbol.get(symbol)) {
                                    if (transaction.getType() == TransactionType.BUY) {
                                        totalAmount += transaction.getAmount();
                                        totalPrice += transaction.getAmount() * transaction.getPrice();
                                    } else if (transaction.getType() == TransactionType.SELL) {
                                        totalAmount -= transaction.getAmount();
                                        totalPrice -= transaction.getAmount() * transaction.getPrice();
                                    }
                                }

                                double averagePrice = totalAmount != 0 ? totalPrice / totalAmount : 0;

                                double historicalPrice = Double.parseDouble(timeSeriesDataMap.get(symbol).getValues().get(i).getOpen());
                                holdingsMap.put(symbol, new Holding(symbol, totalAmount, averagePrice, historicalPrice));
                            }

                        }
                        portfolio.setDatetime(timeSeriesDataMap.get(0).getValues().get(i).getDatetime());
                        portfolio.setHoldingList(new ArrayList<>(holdingsMap.values()));
                        portfolio.setTotalProfitLoss(holdingsMap.values().stream().mapToDouble(Holding::getProfitLoss).sum());
                        portfolioList.add(portfolio);
                    }

                    return Flux.fromIterable(portfolioList);
                });
    }

    private Map<String, List<Transaction>> groupTransactionsBySymbol(List<Transaction> transactions) {
        return transactions.stream()
                .collect(Collectors.groupingBy(Transaction::getSymbol));
    }

    public Mono<Double> calculateTotalProfitAndLoss(Flux<Holding> holdings) {
        return holdings.map(Holding::getProfitLoss).reduce(0.0, Double::sum);
    }

    private Mono<Map<String, TimeSeriesData>> getTimeSeries(String authHeader, Interval interval) {
        String userId = authHttpClient.getUserSubject(authHeader);

        Flux<String> symbolsFlux = Flux.from(transactionRepository.getTransactionsByUserId(userId)
                .map(Transaction::getSymbol)
                .distinct());

        return symbolsFlux
                .flatMap(symbol ->
                        marketHttpClient.getTimeSeries(authHeader, symbol, interval)
                                .map(timeSeries -> new AbstractMap.SimpleEntry<>(symbol, timeSeries))
                )
                .collectMap(Map.Entry::getKey, Map.Entry::getValue);
    }

}
