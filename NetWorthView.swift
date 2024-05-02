//
//  WalletView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/8/24.
//

import SwiftUI

struct NetWorthView: View {
    @State var wallet: String = ""
    
    var body: some View {
        Text("Net Worth")
            .font(.title2)
        Text(wallet)
            .bold()
            .font(.title2)
            .onAppear {
                getWallet()
            }
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
}

#Preview {
    NetWorthView()
}
