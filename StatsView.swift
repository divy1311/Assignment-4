//
//  StatsView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/12/24.
//

import SwiftUI

struct StatsView: View {
    
    @State var ticker: String
    @State var quote: Quote = Quote(c: -100, d: -100, dp: -1000, h: -100, l: -100, o: -100, pc: -1000, t: -100)
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("High Price: ")
                        .font(.caption)
                        .bold()
                    Text("$\(quote.h, specifier: "%.2f")")
                        .font(.caption)
                }
                HStack {
                    Text("Low Price: ")
                        .font(.caption)
                        .bold()
                    Text("$\(quote.l, specifier: "%.2f")")
                        .font(.caption)
                }
            }
            Spacer()
            VStack(alignment: .leading) {
                HStack {
                    Text("Open Price: ")
                        .font(.caption)
                        .bold()
                    Text("$\(quote.o, specifier: "%.2f")")
                        .font(.caption)
                }
                HStack {
                    Text("Prev. Close: ")
                        .font(.caption)
                        .bold()
                    Text("$\(quote.pc, specifier: "%.2f")")
                        .font(.caption)
                }
            }
            Spacer()
            Spacer()
        }
        .onAppear {
            getQuoteDetails()
        }
    }
    private func getQuoteDetails() {
        if let apiURL = URL(string: "http://127.0.0.1:3000/company/quote?ticker="+ticker) {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let quoteData = data {
                    if let quoteDetailsFromAPI =
                        try? JSONDecoder().decode(Quote.self, from: quoteData) {
                        quote = quoteDetailsFromAPI
                    }
                }
            }.resume()
        }
    }
}

#Preview {
    StatsView(ticker: "AAPL")
}
