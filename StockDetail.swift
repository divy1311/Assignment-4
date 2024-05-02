//
//  StockDetail.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/9/24.
//

import Foundation

final class StockDetail: Identifiable, Decodable {
    var country: String
    var currency: String
    var estimateCurrency: String
    var exchange: String
    var name: String
    var ticker: String
    var ipo: String
    var marketCapitalization: Double
    var shareOutstanding: Double
    var logo: String
    var phone: String
    var weburl: String
    var finnhubIndustry: String

    init(country: String, currency: String, estimateCurrency: String, exchange: String, name: String, ticker: String, ipo: String, marketCapitalization: Double, shareOutstanding: Double, logo: String, phone: String, weburl: String, finnhubIndustry: String) {
        self.country = country
        self.currency = currency
        self.estimateCurrency = estimateCurrency
        self.exchange = exchange
        self.name = name
        self.ticker = ticker
        self.ipo = ipo
        self.marketCapitalization = marketCapitalization
        self.shareOutstanding = shareOutstanding
        self.logo = logo
        self.phone = phone
        self.weburl = weburl
        self.finnhubIndustry = finnhubIndustry
    }
    
}
