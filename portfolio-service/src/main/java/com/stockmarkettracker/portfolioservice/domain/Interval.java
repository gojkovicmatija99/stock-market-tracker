package com.stockmarkettracker.portfolioservice.domain;

import java.util.Arrays;

public enum Interval {
    _1min, _5min, _15min, _30min, _45min, _1h, _2h, _4h, _1day, _1week, _1month;

    @Override
    public String toString() {
        return super.toString().substring(1);
    }

    public static Interval toInterval(String interval) {
        return Interval.valueOf("_" + interval);
    }

    public static boolean isValid(String interval) {
        return Arrays.stream(values()).anyMatch(curr -> curr.toString().equals(interval));
    }
}
