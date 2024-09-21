package com.stockmarkettracker.authservice.domain;

public enum Role {
    ADMIN, USER;

    @Override
    public String toString() {
        return name().toLowerCase();
    }
}