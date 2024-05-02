//
//  Quote.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/8/24.
//

import Foundation

final class Quote: Identifiable, Decodable {
    var c: Double
    var d: Double
    var dp: Double
    var h: Double
    var l: Double
    var o: Double
    var pc: Double
    var t: Double
    
    init(c: Double, d: Double, dp: Double, h: Double, l: Double, o: Double, pc: Double, t: Double) {
        self.c = c
        self.d = d
        self.dp = dp
        self.h = h
        self.l = l
        self.o = o
        self.pc = pc
        self.t = t
    }
}
