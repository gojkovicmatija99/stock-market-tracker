package com.stockmarkettracker.portfolioservice.repository;

import com.stockmarkettracker.portfolioservice.data.GroupedTransactionData;
import org.springframework.data.mongodb.core.ReactiveMongoTemplate;
import org.springframework.data.mongodb.core.aggregation.Aggregation;
import org.springframework.data.mongodb.core.aggregation.GroupOperation;
import org.springframework.data.mongodb.core.aggregation.MatchOperation;
import org.springframework.data.mongodb.core.aggregation.ProjectionOperation;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public class TransactionCustomRepository {

    private final ReactiveMongoTemplate mongoTemplate;

    public TransactionCustomRepository(ReactiveMongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    public Flux<GroupedTransactionData> getTransactionsGroupedBySymbol(String userId) {
        MatchOperation filterUserId = Aggregation.match(Criteria.where("userId").is(userId));

        GroupOperation groupBySymbol = Aggregation.group("symbol")
                .push("$$ROOT").as("transactions");

        ProjectionOperation projectSymbol = Aggregation.project()
                .and("_id").as("symbol")
                .and("transactions").as("transactions");

        Aggregation aggregation = Aggregation.newAggregation(filterUserId, groupBySymbol, projectSymbol);

        return mongoTemplate.aggregate(aggregation, "transactions", GroupedTransactionData.class);
    }
}