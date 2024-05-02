//
//  Favorite.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/8/24.
//

import Foundation
import SwiftData

final class Favorite: Identifiable, Decodable {
    var _id: String
    var ticker: String
    var stockDescription: String
    
    init(_id: String, ticker: String, stockDescription: String) {
        self._id = _id
        self.ticker = ticker
        self.stockDescription = stockDescription
    }
}
