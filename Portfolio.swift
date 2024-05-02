//
//  Portfolio.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/8/24.
//

import Foundation

final class Portfolio: Identifiable, Decodable {
    var _id: String //"660eeafcd457b575cbb31ada
    var stock: String //DELL
    var price: Double //0
    var quantity: Double //9
    var stockDescription: String //Dell Technologies Inc
    
    init(_id: String, stock: String, price: Double, quantity: Double, stockDescription: String) {
        self._id = _id
        self.stock = stock
        self.price = price
        self.quantity = quantity
        self.stockDescription = stockDescription
    }
}
