//
//  AboutView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/12/24.
//

import SwiftUI

struct AboutView: View {
    
    @State var ticker: String
    @State var stockDetail: StockDetail = StockDetail(country: "", currency: "", estimateCurrency: "", exchange: "", name: "AAPL Inc", ticker: "", ipo: "", marketCapitalization: 1.0, shareOutstanding: 1.0, logo: "", phone: "", weburl: "", finnhubIndustry: "")
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading){
                Text("IPO Start Date: ")
                    .font(.caption)
                    .bold().padding(.vertical, 1)
                Text("Industry: ")
                    .font(.caption)
                    .bold().padding(.vertical, 1)
                Text("Webpage: ")
                    .font(.caption)
                    .bold().padding(.vertical, 1)
                Text("Company Peers: ")
                    .font(.caption)
                    .bold().padding(.vertical, 1)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text(stockDetail.ipo)
                    .font(.caption).padding(.vertical, 1)
                Text(stockDetail.finnhubIndustry)
                    .font(.caption).padding(.vertical, 1)
                if !stockDetail.weburl.isEmpty {
                    Link(stockDetail.weburl, destination: URL(string: stockDetail.weburl)!)
                        .font(.caption).padding(.vertical, 1)
                }
                PeersView(ticker: ticker)
                    .padding(1)
            }
        }
        .padding(.trailing, 35) 
        .onAppear {
            getStockDetails()
        }
    }
    
    private func getStockDetails() {
        if let apiURL = URL(string: "http://127.0.0.1:3000/company?ticker="+ticker) {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let stockData = data {
                    if let stockDetailFromAPI =
                        try? JSONDecoder().decode(StockDetail.self, from: stockData) {
                        stockDetail = stockDetailFromAPI
                    }
                }
            }.resume()
        }
    }
}

#Preview {
    AboutView(ticker: "AAPL", stockDetail: StockDetail(country: "", currency: "", estimateCurrency: "", exchange: "", name: "AAPL Inc", ticker: "", ipo: "", marketCapitalization: 1.0, shareOutstanding: 1.0, logo: "", phone: "", weburl: "", finnhubIndustry: ""))
        .environmentObject(ViewModel())
}
