//
//  HomePortfolioView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/13/24.
//

import SwiftUI

struct HomePortfolioView: View {
    
    @State var portfolio: [Portfolio]
    @State var portfoliosHome: [PortfolioHome]
    
    var body: some View {
        VStack {
            
        }
//        ForEach(portfoliosHome, id: \.id) { portfolio in
//            NavigationLink(destination: StockDetailView(ticker: portfolio.stock)) {
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text(portfolio.stock)
//                            .font(.title2)
//                            .bold()
//                            .padding(.bottom, 1)
//                        Text("\(Int(portfolio.quantity)) shares")
//                            .font(.headline)
//                            .foregroundStyle(.secondary)
//                    }
//                    Spacer()
//                    VStack(alignment: .trailing) {
//                        Text("$\(portfolio.quantity * portfolio.price, specifier: "%.2f")")
//                            .font(.headline)
//                            .bold()
//                            .padding(.bottom, 1)
//                        if portfolio.priceChange != 0 {
//                            Image(systemName: portfolio.priceChange > 0 ? "arrow.up.right" : "arrow.down.right")
//                                .foregroundColor(portfolio.priceChange > 0 ? .green : .red)
//                        }
//                        Text("$\(portfolio.priceChange, specifier: "%.2f")")
//                            .font(.subheadline)
//                            .foregroundColor(portfolio.priceChange > 0 ? .green : (portfolio.priceChange < 0 ? .red : .black))
//                        Text("(\(portfolio.pricePercentageChange, specifier: "%.2f")%)")
//                            .font(.subheadline)
//                            .foregroundColor(portfolio.priceChange > 0 ? .green : (portfolio.priceChange < 0 ? .red : .black))
//                    }
//                }
//            }
//        }
//        .onMove { from, to in
//            portfoliosHome.move(fromOffsets: from, toOffset: to)
//        }
    }
}
