//
//  CashBalanceView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/8/24.
//

import SwiftUI

struct CashBalanceView: View {
    @State var wallet: String = ""
    @State var stockValue: Double = 0.0
    var body: some View {
        Text("Cash Balance")
            .font(.title2)
        if wallet.isEmpty {
            VStack {
            
            } .onAppear {
                getPortfolio() { stocks in
                    ForEach(stocks) {
                        stock in
                        stockValue = stockValue + (stock?.price ?? 1.0)*(Double(stock?.quantity) ?? 1)
                    }
                }
            }
        }
        else {
            Text("$\(Double(wallet) ?? 0, specifier: "%.2f")")
                .bold()
                .font(.title2)
        }
    }
    
    private func getPortfolio(completion: @escaping ([Portfolio]?) -> Void) {
        let apiURL = URL(string: "http://127.0.0.1:3000/bought")
            URLSession.shared.dataTask(with: apiURL!) {data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
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
    CashBalanceView()
}
