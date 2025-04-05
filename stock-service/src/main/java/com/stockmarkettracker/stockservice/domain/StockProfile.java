package com.stockmarkettracker.stockservice.domain;

import com.stockmarkettracker.stockservice.data.ApiResponseData;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class StockProfile extends ApiResponseData {
    private String symbol;
    private String name;
    private String exchange;
    private String mic_code;
    private String sector;
    private String industry;
    private Integer employees;
    private String website;
    private String description;
    private String type;
    private String CEO;
    private String address;
    private String address2;
    private String city;
    private String zip;
    private String state;
    private String country;
    private String phone;
} 