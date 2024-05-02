//
//  InsightsView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/11/24.
//

import SwiftUI

struct InsightsView: View {
    @State var ticker: String
    @State var name: String
    @State private var sentiments: [Sentiments] = []
    @State private var sentiArray: [Double] = [0, 0, 0, 0, 0, 0]
    
    var body: some View {
        VStack {
            if !sentiments.isEmpty {
                HStack(alignment: .top, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(name)
                            .font(.caption)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                        Text("Total")
                            .font(.caption)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                        Text("Positive")
                            .font(.caption)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                        Text("Negative")
                            .font(.caption)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                    }
                    .frame(width: 100)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("MSPR")
                            .font(.caption)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                        Text("\(sentiArray[0], specifier: "%.2f")")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                        Text("\(sentiArray[1], specifier: "%.2f")")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                        Text("\(sentiArray[2], specifier: "%.2f")")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                    }
                    .frame(width: 100)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Change")
                            .bold()
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                        Text("\(sentiArray[3], specifier: "%.2f")")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                        Text("\(sentiArray[4], specifier: "%.2f")")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                        Text("\(sentiArray[5], specifier: "%.2f")")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                    }
                    .frame(width: 100)
                    
                }
            } else {
                Text("Loading...")
                    .font(.caption)
            }
        }
        .onAppear {
            getNews()
        }
    }
    
    private func getNews() {
        if let apiURL = URL(string: "http://127.0.0.1:3000/company/sentiments?ticker=\(ticker)") {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data, let decodedSentiments = try? JSONDecoder().decode([Sentiments].self, from: data) {
                    DispatchQueue.main.async {
                        sentiments = decodedSentiments
                        updateSentimentsArray()
                    }
                }
            }.resume()
        }
    }
    
    private func updateSentimentsArray() {
        sentiArray = [0, 0, 0, 0, 0, 0]
        sentiments.forEach { sentiment in
            if sentiment.change < 0 {
                sentiArray[5] += sentiment.change
            }
            if sentiment.change >= 0 {
                sentiArray[4] += sentiment.change
            }
            if sentiment.mspr < 0 {
                sentiArray[2] += sentiment.mspr
            }
            if sentiment.mspr >= 0 {
                sentiArray[1] += sentiment.mspr
            }
            sentiArray[3] += sentiment.change
            sentiArray[0] += sentiment.mspr
        }
    }
}
#Preview {
    InsightsView(ticker: "AAPL", name: "Apple Inc")
}
