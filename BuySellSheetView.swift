//
//  BuySellSheetView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/12/24.
//

import SwiftUI

struct BuySellSheetView: View {

    @State var ticker: String
    @State var tickerName: String
    @State private var quantity = ""
    @State private var price = 171.09
    @State private var wallet: String = "0"
    @State private var quote: Quote = Quote(c: -1.00, d: -1.00, dp: -1.00, h: -1.00, l: -1.00, o: -1.00, pc: -1.00, t: -1.00)
    @State var portfolios: [Portfolio] = []
    @State var portfolioChosen: Portfolio = Portfolio(_id: "", stock: "", price: -1.0, quantity: -1.0, stockDescription: "")
    @State private var showNotEnoughMoneyToast = false
    @State private var showNotEnoughtoSellToast = false
    @State private var zeroOrNegativeSharesBuyToast = false
    @State private var zeroOrNegativeSharesSellToast = false
    @State private var invalidInputToast = false
    @State private var stockFound = false
    @State var buy = true
    @State var showSheet = false
    @State var showCongratulationsScreen: Bool = false
    @Environment(\.dismiss) var dismissBuySellSheet
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @State private var opacity: Double = 0.0
    @State private var navigateToHome: Bool = false
    @State private var shareQuantity  = ""
    var body: some View {
        NavigationStack {
            VStack {
                if !showCongratulationsScreen {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "xmark")
                                .onTapGesture {
                                    presentationMode.wrappedValue.dismiss()
                                }
                        }.padding()
                        VStack(alignment: .center) {
                            Text("Trade \(tickerName) shares")
                                .bold()
                        }
                        Spacer()
                        VStack {
                            if quote.c >= 0 {
                                HStack(alignment: .lastTextBaseline) {
                                    TextField("0", text: $quantity)
                                        .keyboardType(.numberPad)
                                        .padding()
                                        .font(.system(size: 72))
                                    Spacer()
                                    Text("Shares")
                                        .padding(.vertical, -40)
                                        .font(.title)
                                }
                                HStack {
                                    Spacer()
                                    if quantity == "" {
                                        Text("x $\(quote.c, specifier: "%.2f")/share = $0.00")
                                            .font(.caption)
                                    } else {
                                        Text("x $\(quote.c, specifier: "%.2f")/share = $\(quote.c*(Double(quantity) ?? 0.00), specifier: "%.2f")")
                                            .font(.caption)
                                    }
                                }
                            }
                        }.padding()
                        Spacer()
                        VStack(alignment: .center) {
                            Text("$\(Double(wallet)!, specifier: "%.2f") available to buy \(ticker)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 20)
                            HStack {
                                Spacer()
                                Spacer()
                                Button(action: {
                                    if quantity == "" {
                                        withAnimation {
                                            invalidInputToast = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            withAnimation {
                                                invalidInputToast = false
                                            }
                                        }
                                    } else if !checkIntegerValidity(input: quantity) {
                                        withAnimation {
                                            invalidInputToast = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            withAnimation {
                                                invalidInputToast = false
                                            }
                                        }
                                    } else if Int(quantity)! <= 0 {
                                        withAnimation {
                                            zeroOrNegativeSharesBuyToast = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            withAnimation {
                                                zeroOrNegativeSharesBuyToast = false
                                            }
                                        }
                                    } else if Double(quantity)!*quote.c > Double(wallet)!  {
                                        withAnimation {
                                            showNotEnoughMoneyToast = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            withAnimation {
                                                showNotEnoughMoneyToast = false
                                            }
                                        }
                                    } else {
                                        updateWallet(amount: Double(wallet)! - (quote.c*Double(quantity)!))
                                        buy = true
                                        shareQuantity = quantity
                                        showSheet = true
                                        showCongratulationsScreen = true
                                        updatePortfolio()
                                    }
                                }) {
                                    Text("Buy").padding(.horizontal, 60).padding(.vertical, 12)
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                        .background(Color.green)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                }
                                Spacer()
                                Button(action: {
                                    if quantity == "" {
                                        withAnimation {
                                            invalidInputToast = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            withAnimation {
                                                invalidInputToast = false
                                            }
                                        }
                                    } else if !checkIntegerValidity(input: quantity) {
                                        withAnimation {
                                            invalidInputToast = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            withAnimation {
                                                invalidInputToast = false
                                            }
                                        }
                                    } else if Int(quantity)! <= 0 {
                                        withAnimation {
                                            zeroOrNegativeSharesSellToast = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            withAnimation {
                                                zeroOrNegativeSharesSellToast = false
                                            }
                                        }
                                    } else if portfolioChosen.quantity < Double(quantity)! {
                                        withAnimation {
                                            showNotEnoughtoSellToast = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            withAnimation {
                                                showNotEnoughtoSellToast = false
                                            }
                                        }
                                    } else {
                                        updateWallet(amount: (quote.c*Double(quantity)!) + Double(wallet)!)
                                        buy = false
                                        showSheet = true
                                        updatePortfolio()
                                        shareQuantity = quantity
                                        showCongratulationsScreen = true
                                    }
                                }) {
                                    Text("Sell").padding(.horizontal, 60).padding(.vertical, 12)
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                        .background(Color.green)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                }
                                Spacer()
                                Spacer()
                            }
                        }
                        .padding(.bottom)
                    }
                }
                else {
                    VStack {
                        Spacer()
                        Text("Congratulations!")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                        if buy {
                            if Double(shareQuantity) == 1 {
                                Text("You have successfully bought \(shareQuantity) share of \(ticker)")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                Text("You have successfully bought \(shareQuantity) shares of \(ticker)")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        } else {
                            if Double(shareQuantity) == 1 {
                                Text("You have successfully sold \(shareQuantity) share of \(ticker)")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                Text("You have successfully sold \(shareQuantity) shares of \(ticker)")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                        Spacer()
                        Button(action: {
                            print("Quantity ==== " + quantity)
                            dismiss()
                            if !buy {
                                NavigationUtil.popToRootView()
                            }
                        }) {
                            Text("Done")
                                .padding(.horizontal, 150).padding(.vertical, 15)
                                .foregroundStyle(Color.green)
                                .background(Color.white)
                                .font(.subheadline)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                    }
                    .padding(.vertical, 0)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            opacity = 1.0
                        }
                    }
                    .foregroundStyle(Color.white)
                }
            }
            //        .sheet(isPresented: $showSheet, onDismiss: {
            //            dismissBuySellSheet()
            //        }) {
            //            BuySellSheetCongratulationsView(buy: buy, shares: quantity, ticker: ticker)
            //        }
            .onAppear {
                getWallet()
                getQuote(ticker: ticker)
                getPortfolio { portfolios in
                    if let portfolios = portfolios {
                        DispatchQueue.main.async {
                            for portfolio in portfolios {
                                if portfolio.stock == ticker {
                                    portfolioChosen = portfolio
                                    break
                                }
                            }
                        }
                    }
                }
            }
            .overlay(
                Group {
                    if showNotEnoughtoSellToast {
                        ToastView(message: "Not enough shares to sell")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .padding(.top)
                    } else if zeroOrNegativeSharesSellToast {
                        ToastView(message: "Cannot sell non-positive shares")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .padding(.top)
                    } else if zeroOrNegativeSharesBuyToast {
                        ToastView(message: "Cannot buy non-positive shares")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .padding(.top)
                    } else if invalidInputToast {
                        ToastView(message: "Please enter a valid amount")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .padding(.top)
                    } else if showNotEnoughMoneyToast {
                        ToastView(message: "Not enough money to buy")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .padding(.top)
                    }
                }
            )
        }
    }
    
    private func getQuote(ticker: String) {
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
    
    private func getWallet() {
        if let apiURL = URL(string: "http://127.0.0.1:3000/getWallet") {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let walletData = data {
                    print(String(data: walletData, encoding: .utf8) ?? "Error")
                    wallet = String(data: walletData, encoding: .utf8) ?? "Error"
                }
            }.resume()
        }
    }

    private func updatePortfolio() {
        print(quantity)
        guard let quantityDouble = Double(quantity), quantityDouble != 0 else {
            print("Invalid quantity")
            return
        }
        
        var updatedQuantity = 0
        var avgPrice = 0.00
        
        if buy {
            var portfolioQuantity = Int(portfolioChosen.quantity)
            if portfolioQuantity == -1 {
                portfolioQuantity = 0
            }
            updatedQuantity = portfolioQuantity + Int(quantityDouble)
            if portfolioChosen.price == -1 {
                portfolioChosen.price = 0
            }
            let totalPrice = (portfolioChosen.quantity * portfolioChosen.price) + (quantityDouble * quote.c)
            avgPrice = totalPrice / Double(updatedQuantity)
        } else {
            avgPrice = portfolioChosen.price
            updatedQuantity = Int(portfolioChosen.quantity) - Int(quantityDouble)
        }
        avgPrice = Double(String(format: "%.2f", avgPrice)) ?? avgPrice
        if let encodedTickerName = tickerName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let apiURL = URL(string: "http://127.0.0.1:3000/updateStock?ticker=\(ticker)&quantity=\(updatedQuantity)&price=\(avgPrice)&stockDescription=\(encodedTickerName)") {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Network request failed: \(error.localizedDescription)")
                    return
                }
                getPortfolio { portfolios in
                    if let portfolios = portfolios {
                        DispatchQueue.main.async {
                            for portfolio in portfolios {
                                if portfolio.stock == ticker {
                                    portfolioChosen = portfolio
                                    stockFound = true
                                    break
                                }
                            }
                        }
                    }
                }
                quantity = ""
                getWallet()
            }.resume()
        } else {
            print("Failed to create URL")
        }
    }
    
    
    private func updateWallet(amount: Double) {
        let amountStr = String(format: "%.2f", amount)
        if let apiURL = URL(string: "http://127.0.0.1:3000/updateWallet?amount=\(amountStr)") {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                getWallet()
            }.resume()
        }
    }
    
    private func checkIntegerValidity(input: String) -> Bool {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        if Int(trimmedInput) != nil {
            return true
        } else {
            return false
        }
    }
}

#Preview {
    BuySellSheetView(ticker: "AAPL", tickerName: "")
}
