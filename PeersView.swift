//
//  PeersView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/12/24.
//

import SwiftUI

struct PeersView: View {
    
    @State private var peers: [String] = []
    @State var ticker: String
    @State var peerFound = false
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing:0) {
                ForEach(peers.indices, id: \.self) { index in
                    NavigationLink(destination: StockDetailView(ticker: peers[index])) {
                        Text("\(peers[index])\(index < peers.count - 1 ? ", " : " ")")
                            .font(.caption)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(0)
        }
        .padding(.vertical, 0)
        .onAppear {
            getPeers()
        }
    }
    
    private func getPeers() {
        if let apiURL = URL(string: "http://127.0.0.1:3000/company/peers?ticker=\(ticker)") {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data, let decodedPeers = try? JSONDecoder().decode([String].self, from: data) {
                    DispatchQueue.main.async {
                        peers = decodedPeers
                        peers = peers.filter { !$0.contains(".") }
                        viewModel.peerFound = true
                        print(viewModel.peerFound)
                    }
                }
            }.resume()
        }
    }
}

struct PeersView_Previews: PreviewProvider {
    static var previews: some View {
        PeersView(ticker: "AAPL")
            .environmentObject(ViewModel())
    }
}
