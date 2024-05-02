//
//  Sentiments.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/9/24.
//

import Foundation

final class Sentiments: Identifiable, Decodable {
    var symbol: String
    var year: Int
    var month: Int
    var change: Double
    var mspr: Double
    
    init(symbol: String, year: Int, month: Int, change: Double, mspr: Double) {
        self.symbol = symbol
        self.year = year
        self.month = month
        self.change = change
        self.mspr = mspr
    }
}
