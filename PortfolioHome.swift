//
//  PortfolioHome.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/9/24.
//

import Foundation
import Combine

final class PortfolioHome: Identifiable, ObservableObject {
    var _id: String //"660eeafcd457b575cbb31ada
    var stock: String //DELL
    var price: Double //0
    var quantity: Double //9
    var stockDescription: String //Dell Technologies Inc
    @Published var c: Double
    @Published var d: Double
    @Published var dp: Double
    var anyCancellable: AnyCancellable? = nil
    
    init(_id: String, stock: String, price: Double, quantity: Double, stockDescription: String, c: Double, d: Double, dp: Double) {
        self._id = _id
        self.stock = stock
        self.price = price
        self.quantity = quantity
        self.stockDescription = stockDescription
        self.c = c
        self.d = d
        self.dp = dp
        anyCancellable = $c.combineLatest($d, $dp)
        .sink { [weak self] (_, _, _) in
            self?.objectWillChange.send()
        }
    }
    
}

