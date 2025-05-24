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

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class PortfolioService {
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
        return Mono.zip(holdingFlux.collectList(), calculateTotalPrice(holdingFlux), calculateTotalProfitAndLoss(holdingFlux))
                .map(tuple -> new Portfolio(
                        null,
                        tuple.getT1(),
                        tuple.getT2(),
                        tuple.getT3()
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

                    Integer commonTimeSeriesSize = getCommonTimeSeriesSize(timeSeriesDataMap);
                    Map<String, List<Transaction>> groupedBySymbol = groupTransactionsBySymbol(transactions);

                    List<Portfolio> portfolioList = new ArrayList<>();
                    if (commonTimeSeriesSize == null) {
                        return Flux.empty();
                    }
                    for (int i = 0; i < commonTimeSeriesSize; i++) {
                        Portfolio portfolio = new Portfolio();
                        Map<String, Holding> holdingsMap = new HashMap<>();
                        String portfolioDateTime = null;

                        for (Map.Entry<String, TimeSeriesData> entry : timeSeriesDataMap.entrySet()) {
                            String symbol = entry.getKey();
                            TimeSeriesData timeSeriesData = entry.getValue();

                            if (!groupedBySymbol.containsKey(symbol)) {
                                continue;
                            }
                            if (timeSeriesData == null || timeSeriesData.getValues() == null || timeSeriesData.getValues().isEmpty()) {
                                continue;
                            }

                            if (portfolioDateTime == null) {
                                portfolioDateTime = timeSeriesData.getValues().get(i).getDatetime().replace(" ", "T");
                            }

                            Date portfolioDate = getDate(portfolioDateTime);
                            List<Transaction> up2dateTransactions = groupedBySymbol.get(symbol).stream().filter(t -> !t.getDate().after(portfolioDate)).toList();

                            double totalAmount = up2dateTransactions.stream()
                                    .mapToDouble(t -> t.getType() == TransactionType.BUY ? t.getAmount() : -t.getAmount())
                                    .sum();

                            double totalPrice = up2dateTransactions.stream()
                                    .mapToDouble(t -> t.getType() == TransactionType.BUY
                                            ? t.getAmount() * t.getPrice()
                                            : -t.getAmount() * t.getPrice())
                                    .sum();

                            double averagePrice = totalAmount != 0 ? totalPrice / totalAmount : 0;
                            double historicalPrice = Double.parseDouble(timeSeriesData.getValues().get(i).getOpen());
                            holdingsMap.put(symbol, new Holding(symbol, totalAmount, averagePrice, historicalPrice));
                        }

                        portfolio.setDatetime(portfolioDateTime);
                        portfolio.setHoldingList(new ArrayList<>(holdingsMap.values()));
                        portfolio.setTotalProfitLoss(holdingsMap.values().stream().mapToDouble(Holding::getProfitLoss).sum());
                        portfolioList.add(portfolio);
                    }

                    return Flux.fromIterable(portfolioList);
                });
    }

    private Integer getCommonTimeSeriesSize(Map<String, TimeSeriesData> timeSeriesDataMap) {
        Integer commonTimeSeriesSize = null;
        for (Map.Entry<String, TimeSeriesData> entry : timeSeriesDataMap.entrySet()) {
            String symbol = entry.getKey();
            TimeSeriesData data = entry.getValue();
            if (data != null) {
                commonTimeSeriesSize = commonTimeSeriesSize == null ? Integer.MAX_VALUE : commonTimeSeriesSize;
                commonTimeSeriesSize = Math.min(commonTimeSeriesSize, data.getValues().size());
            }
        }

        return commonTimeSeriesSize;
    }

    private static Date getDate(String portfolioDateTime) {
        SimpleDateFormat dateFormatWithTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
        SimpleDateFormat dateFormatWithoutTime = new SimpleDateFormat("yyyy-MM-dd");
        Date portfolioDate;
        try {
            try {
                portfolioDate = dateFormatWithTime.parse(portfolioDateTime);
            } catch (ParseException e) {
                portfolioDate = dateFormatWithoutTime.parse(portfolioDateTime);
            }
        } catch (ParseException e) {
            throw new RuntimeException("Failed to parse date: " + portfolioDateTime, e);
        }
        return portfolioDate;
    }

    private Map<String, List<Transaction>> groupTransactionsBySymbol(List<Transaction> transactions) {
        return transactions.stream()
                .collect(Collectors.groupingBy(Transaction::getSymbol));
    }

    public Mono<Double> calculateTotalProfitAndLoss(Flux<Holding> holdings) {
        return holdings.map(Holding::getProfitLoss).reduce(0.0, Double::sum);
    }

    public Mono<Double> calculateTotalPrice(Flux<Holding> holdings) {
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
