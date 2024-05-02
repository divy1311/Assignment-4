//
//  SearchResult.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/12/24.
//

import Foundation

final class SearchResult: Decodable, Identifiable {
    
    var description: String
    var displaySymbol: String
    var symbol: String
    var type: String
    
    init(description: String, displaySymbol: String, symbol: String, type: String) {
        self.description = description
        self.displaySymbol = displaySymbol
        self.symbol = symbol
        self.type = type
    }
}
