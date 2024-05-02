//
//  News.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/11/24.
//

import Foundation

final class News: Identifiable, Decodable {
    var source: String
    var datetime: Int
    var headline: String
    var url: String
    var summary: String
    var image: String
    
    init(source: String, datetime: Int, headline: String, url: String, summary: String, image: String) {
        self.source = source
        self.datetime = datetime
        self.headline = headline
        self.url = url
        self.summary = summary
        self.image = image
    }
}
