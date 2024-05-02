//
//  FavoriteHome.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/8/24.
//

import Foundation
import Combine

final class FavoriteHome: Identifiable, ObservableObject {
    
    var _id: String
    var ticker: String
    var stockDescription: String
    @Published var c: Double
    @Published var dp: Double
    @Published var d: Double
    var anyCancellable: AnyCancellable? = nil
    
    init(_id: String, ticker: String, stockDescription: String, c: Double, dp: Double, d: Double) {
        self._id = _id
        self.ticker = ticker
        self.stockDescription = stockDescription
        self.c = c
        self.dp = dp
        self.d = d
        anyCancellable = $c.combineLatest($d, $dp)
        .sink { [weak self] (_, _, _) in
            self?.objectWillChange.send()
        }
    }
}
