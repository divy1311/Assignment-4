//
//  QuoteDictionary.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/13/24.
//

import Foundation

class QuoteDictionary: ObservableObject {
    @Published var quotes: [String: Quote]
    
    init(quotes: [String: Quote] = [:]) {
        self.quotes = quotes
    }
}
