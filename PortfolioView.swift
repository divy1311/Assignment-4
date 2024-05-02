//
//  PortfolioView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/12/24.
//

import SwiftUI

struct PortfolioView: View {
    
    @State var ticker: String
    @State var tickerName: String
    @State var quote: Quote
    @State var portfolios: [Portfolio] = []
    @State var portfolioChosen: Portfolio = Portfolio(_id: "", stock: "", price: -1.0, quantity: -1.0, stockDescription: "")
    @State private var stockFound = false
    @State private var buySellStock = false
    @State private var portfolioChecked = false
    @EnvironmentObject var portfolioViewModel: PortfolioViewModel
    var body: some View {
                VStack {
                    if stockFound && portfolioChecked {
                        HStack(alignment: .center){
                            Spacer()
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Shares Owned: ")
                                        .font(.caption)
                                        .bold()
                                    Text("\(portfolioChosen.quantity, specifier: "%.2f")")
                                        .font(.caption)
                                }.padding(.vertical, 2)
                                HStack {
                                    Text("Avg. Cost / Share: ")
                                        .font(.caption).bold()
                                    Text("$\(portfolioChosen.price, specifier: "%.2f")")
                                        .font(.caption)
                                }.padding(.vertical, 2)
                                HStack {
                                    Text("Total Cost: ")
                                        .font(.caption).bold()
                                    Text("$\(portfolioChosen.quantity*portfolioChosen.price, specifier: "%.2f")")
                                        .font(.caption)
                                }.padding(.vertical, 2)
                                HStack {
                                    Text("Change: ")
                                        .font(.caption).bold()
                                    Text("$\((quote.c-portfolioChosen.price)*portfolioChosen.quantity, specifier: "%.2f")")
                                        .font(.caption)
                                        .foregroundStyle(portfolioChosen.price-quote.c < 0.001 ? Color.green : portfolioChosen.price-quote.c > 0.001 ? Color.red : Color.black)
                                }.padding(.vertical, 2)
                                HStack {
                                    Text("Market Value: ")
                                        .font(.caption).bold()
                                    Text("$\(portfolioChosen.quantity*quote.c, specifier: "%.2f")")
                                        .font(.caption)
                                        .foregroundStyle(portfolioChosen.price-quote.c < 0.001 ? Color.green : portfolioChosen.price-quote.c > 0.01 ? Color.red : Color.black)
                                }.padding(.vertical, 2)
                            }
                            Spacer()
                            VStack {
                                Button(action: trade) {
                                    Text("Trade").padding(.horizontal, 50).padding(.vertical, 15)
                                        .foregroundStyle(.white)
                                        .background(Color.green)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                }
                            }
                            Spacer()
                        }
                        .sheet(isPresented: $buySellStock, onDismiss: {
                            print("Dismiss called")
                            stockFound = false
                            portfolioChecked = false
                            portfolioViewModel.portfolioShow = false
                            getPortfolio { portfolios in
                                if let portfolios = portfolios {
                                    print("In getPortfolio")
                                    DispatchQueue.main.async {
                                        print(portfolios)
                                        for portfolio in portfolios {
                                            print(portfolio.stock + " ", ticker + " ", portfolio.quantity)
                                            if portfolio.stock == ticker {
                                                portfolioChosen = portfolio
                                                stockFound = true
                                                break
                                            }
                                        }
                                        portfolioChecked = true
                                        portfolioViewModel.portfolioShow = false
                                    }
                                }
                            }
                        }) {
                            BuySellSheetView(ticker: ticker, tickerName: portfolioChosen.stockDescription)
                        }
                        
                    } else if portfolioChecked {
                        HStack {
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("You have 0 shares of \(ticker).")
                                    .font(.caption)
                                Text("Start trading!")
                                    .font(.caption)
                            }
                            Spacer()
                            VStack {
                                Button(action: trade) {
                                    Text("Trade").padding(.horizontal, 50).padding(.vertical, 15)
                                        .foregroundStyle(.white)
                                        .background(Color.green)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                }
                            }
                            Spacer()
                        }
                        .sheet(isPresented: $buySellStock, onDismiss: {
                            print("Dismiss called")
                            stockFound = false
                            portfolioChecked = false
                            portfolioViewModel.portfolioShow = false
                            getPortfolio { portfolios in
                                if let portfolios = portfolios {
                                    print("In getPortfolio")
                                    DispatchQueue.main.async {
                                        print(portfolios)
                                        for portfolio in portfolios {
                                            print(portfolio.stock + " ", ticker + " ", portfolio.quantity)
                                            if portfolio.stock == ticker {
                                                portfolioChosen = portfolio
                                                stockFound = true
                                                break
                                            }
                                        }
                                        portfolioChecked = true
                                        portfolioViewModel.portfolioShow = true
                                    }
                                }
                            }
                        }) {
                            BuySellSheetView(ticker: ticker, tickerName: tickerName)
                        }
                    }
        }
        .onAppear {
            stockFound = false
            portfolioChecked = false
            portfolioViewModel.portfolioShow = false
            getPortfolio { portfolios in
                if let portfolios = portfolios {
                    DispatchQueue.main.async {
                        for portfolio in portfolios {
                            print(portfolio.stock + " ", ticker + " ", portfolio.quantity)
                            if portfolio.stock == ticker {
                                portfolioChosen = portfolio
                                stockFound = true
                                break
                            }
                        }
                        portfolioChecked = true
                        portfolioViewModel.portfolioShow = true
                    }
                }
            }
        }
    }
    
    private func trade() {
        buySellStock = true
    }
    
    private func getPortfolio(completion: @escaping ([Portfolio]?) -> Void) {
        let apiURL = URL(string: "http://127.0.0.1:3000/bought")
            URLSession.shared.dataTask(with: apiURL!) {data, response, error in
                DispatchQueue.main.async {
                if let data = data {
                    do {
                        print(String(data: data, encoding: .utf8) ?? "Error")
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode([Portfolio].self, from: data)
                        completion(decodedData)
                    } catch {
                        print("Error: ", error)
                        completion(nil)
                    }
                }
            }
        }.resume()
    }
}

#Preview {
    PortfolioView(ticker: "AAPL", tickerName: "Apple Inc", quote: Quote(c: -100, d: -100, dp: -1000, h: -100, l: -100, o: -100, pc: -1000, t: -100)).environmentObject(PortfolioViewModel())
}
