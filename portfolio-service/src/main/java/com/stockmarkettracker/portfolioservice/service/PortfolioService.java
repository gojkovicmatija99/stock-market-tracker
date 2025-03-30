package com.stockmarkettracker.portfolioservice.service;

import com.stockmarkettracker.portfolioservice.data.TimeSeriesData;
import com.stockmarkettracker.portfolioservice.domain.*;
import com.stockmarkettracker.portfolioservice.httpClient.AuthHttpClient;
import com.stockmarkettracker.portfolioservice.httpClient.MarketHttpClient;
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

    public Mono<Portfolio> getPortfolio(String authHeader) {
        String userId = authHttpClient.getUserSubject(authHeader);
        Flux<Transaction> transactionFlux = transactionRepository.getTransactionsByUserId(userId);
        Flux<Holding> holdingFlux = buildHoldingsFromTransactions(authHeader, transactionFlux).onErrorResume(Mono::error);
        return Mono.zip(holdingFlux.collectList(), calculateTotalProfitAndLoss(holdingFlux))
                .map(tuple -> new Portfolio(
                        tuple.getT1(),
                        tuple.getT2()
                ));
    }

    // TODO Blocking
    public Flux<Portfolio> getPortfolioHistory(String authHeader, Interval interval) {
        String userId = authHttpClient.getUserSubject(authHeader);
        Flux<Transaction> transactionFlux = transactionRepository.getTransactionsByUserId(userId);
        Mono<Map<String, TimeSeriesData>> timeSeriesDataMono = getTimeSeries(authHeader, interval);

        // Use Mono.zip to combine the results of Flux<Transaction> and Mono<Map<String, TimeSeriesData>>
        return Mono.zip(transactionFlux.collectList(), timeSeriesDataMono)
                .flatMapMany(tuple -> {
                    List<Transaction> transactions = tuple.getT1();  // List of transactions
                    Map<String, TimeSeriesData> timeSeriesDataMap = tuple.getT2();  // Map of time series data

                    // Group transactions by symbol
                    Map<String, List<Transaction>> groupedBySymbol = groupTransactionsBySymbol(transactions);

                    // Create a list to store portfolios for each time point
                    List<Portfolio> portfolioList = new ArrayList<>();

                    for (int i = 0; i < MAX_HISTORY_POINTS; i++) {
                        Portfolio portfolio = new Portfolio();
                        Map<String, Holding> holdingsMap = new HashMap<>();
                        for (Map.Entry<String, TimeSeriesData> entry : timeSeriesDataMap.entrySet()) {
                            String symbol = entry.getKey();


                            // For each symbol, calculate the total position and profit/loss
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

                                // Use historical price from TimeSeries to calculate Profit/Loss at this time point
                                double historicalPrice = Double.parseDouble(timeSeriesDataMap.get(symbol).getValues().get(i).getOpen());
                                holdingsMap.put(symbol, new Holding(symbol, totalAmount, averagePrice, historicalPrice));
                            }

                        }
                        portfolio.setHoldingList(new ArrayList<>(holdingsMap.values()));
                        portfolio.setTotalProfitLoss(holdingsMap.values().stream().mapToDouble(Holding::getProfitLoss).sum());
                        portfolioList.add(portfolio);
                    }

                    // Iterate over all symbols in the time series data


                    // Return a Flux containing the portfolio history for all time points
                    return Flux.fromIterable(portfolioList);
                });
    }

    private Map<String, List<Transaction>> groupTransactionsBySymbol(List<Transaction> transactions) {
        // Group transactions by symbol
        return transactions.stream()
                .collect(Collectors.groupingBy(Transaction::getSymbol));
    }

    private Flux<Holding> buildHoldingsFromTransactions(String authHeader, Flux<Transaction> transactions) {
        return transactions
                .collect(Collectors.groupingBy(Transaction::getSymbol))
                .flatMapMany(symbolMap -> Flux.fromIterable(symbolMap.entrySet())
                        .flatMap(entry -> {
                            String symbol = entry.getKey();
                            List<Transaction> symbolTransactions = entry.getValue();

                            double totalAmount = 0;
                            double totalPrice = 0;
                            for (Transaction transaction : symbolTransactions) {
                                if (transaction.getType() == TransactionType.BUY) {
                                    totalAmount += transaction.getAmount();
                                    totalPrice += transaction.getAmount() * transaction.getPrice();
                                } else if (transaction.getType() == TransactionType.SELL) {
                                    totalAmount -= transaction.getAmount();
                                    totalPrice -= transaction.getAmount() * transaction.getPrice();
                                }
                            }

                            if (totalAmount < 0) {
                                return Mono.error(new IllegalStateException("Sell transactions exceed buy transactions for symbol: " + symbol));
                            }

                            double averagePrice = totalAmount != 0 ? totalPrice / totalAmount : 0;

                            Mono<Double> priceMono = marketHttpClient.getMarketPrice(authHeader, symbol);
                            double finalTotalAmount = totalAmount;
                            return priceMono
                                    .onErrorResume(Mono::error)
                                    .flatMap(price -> {
                                        Holding holding = new Holding(symbol, finalTotalAmount, averagePrice, price);
                                        return Mono.just(holding);
                                    });
                        }));
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
