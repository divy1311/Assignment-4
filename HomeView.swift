//
//  HomeView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/8/24.
//

import SwiftUI

struct HomeView: View {
    @State var stock = ""
    @State var favorites: [Favorite] = []
    @State var favoritesHome: [FavoriteHome] = []
    @State var portfolio: [Portfolio] = []
    @State var wallet: String = ""
    @State var stockValue: Double = 0
    @State var quote: [String: Quote] = [:]
    @State var portfoliosHome: [PortfolioHome] = []
    @State private var savedOrder: [String] = []
    @State private var savedPortfolioOrder: [String] = []
    @State private var favoritesOrdered = false
    @StateObject private var viewModel = SearchViewModel()
    @State private var dummyState = false
    @Environment(\.editMode) var editMode
    @State private var timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    @State private var favoritesLoaded = false
    @State private var portfolioLoaded = false
    @State private var walletDataFetched = false

    var body: some View {
        NavigationStack {
            VStack {
                if walletDataFetched && favoritesLoaded && portfolioLoaded {
                    VStack {
                        if viewModel.isSearching {
                            List(viewModel.results, id: \.id) { result in
                                NavigationLink(destination: StockDetailView(ticker: result.symbol)) {
                                    VStack (alignment: .leading) {
                                        Text(result.symbol)
                                            .font(.title3)
                                            .bold()
                                        Text(result.description)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                            }
                        } else {
                            List {
                                Text(Date.now, style: .date)
                                    .padding(5)
                                    .padding(.horizontal, 0)
                                    .font(.title)
                                    .foregroundStyle(.secondary)
                                    .bold()
                                Section(header: Text("Portfolio").font(.subheadline)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Net Worth")
                                                .font(.title2)
                                            if portfolioLoaded && portfoliosHome.count == 0 {
                                                Text("$\((Double(wallet) ?? 0), specifier: "%.2f")")
                                                    .bold()
                                                    .font(.title2)
                                            } else {
                                                Text("$\((Double(wallet) ?? 0) + stockValue, specifier: "%.2f")")
                                                    .bold()
                                                    .font(.title2)
                                            }
                                        }
                                        Spacer()
                                        VStack(alignment: .leading) {
                                            Text("Cash Balance")
                                                .font(.title2)
                                            if wallet.isEmpty {
                                                
                                            } else {
                                                Text("$\(Double(wallet) ?? 0, specifier: "%.2f")")
                                                    .bold()
                                                    .font(.title2)
                                            }
                                        }
                                    }
                                    ForEach(portfoliosHome) { portfolio in
                                        NavigationLink(destination: StockDetailView(ticker: portfolio.stock)) {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text(portfolio.stock)
                                                        .font(.title2)
                                                        .bold()
                                                        .padding(.bottom, 1)
                                                    Text("\(Int(portfolio.quantity)) shares")
                                                        .font(.headline)
                                                        .foregroundStyle(.secondary)
                                                }
                                                Spacer()
                                                VStack(alignment: .trailing) {
                                                    HStack {
                                                        Text("$\(portfolio.quantity * portfolio.price, specifier: "%.2f")")
                                                            .font(.headline)
                                                            .bold()
                                                            .padding(.bottom, 1)
                                                    }
                                                    HStack {
                                                        if portfolio.c - portfolio.price != 0 {
                                                            Image(systemName: portfolio.c - portfolio.price > 0 ? "arrow.up.right" : "arrow.down.right")
                                                                .foregroundColor(portfolio.c - portfolio.price > 0 ? .green : .red)
                                                        }
                                                        Text("$\(portfolio.c - portfolio.price, specifier: "%.2f")")
                                                            .font(.subheadline)
                                                            .foregroundColor(portfolio.c - portfolio.price > 0 ? .green : portfolio.c - portfolio.price < 0 ? .red: .black)
                                                        Text("(\(((portfolio.c - portfolio.price)/portfolio.price)*100, specifier: "%.2f")%)")
                                                            .font(.subheadline)
                                                            .foregroundColor(portfolio.c - portfolio.price > 0 ? .green : portfolio.c - portfolio.price < 0 ? .red: .black)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .onMove { from, to in
                                        portfoliosHome.move(fromOffsets: from, toOffset: to)
                                        savePortfolioOrder()
                                    }
                                }
                                Section(header: Text("Favorites").font(.subheadline)) {
                                    if(favoritesHome.count == 0) {
                                        
                                    } else {
                                        if favoritesOrdered {
                                            ForEach(favoritesHome) { favoriteHome in
                                                NavigationLink(destination: StockDetailView(ticker: favoriteHome.ticker)) {
                                                    HStack {
                                                        VStack (alignment: .leading) {
                                                            Text(favoriteHome.ticker)
                                                                .font(.title2)
                                                                .bold()
                                                                .padding(.bottom, 1)
                                                            Text(favoriteHome.stockDescription)
                                                                .font(.subheadline)
                                                                .foregroundStyle(.secondary)
                                                        }
                                                        Spacer()
                                                        VStack(alignment: .trailing) {
                                                            if let quoteValue = quote[favoriteHome.ticker], quote.keys.contains(favoriteHome.ticker) {
                                                                Text("$\(quoteValue.c, specifier: "%.2f")")
                                                                    .font(.headline)
                                                                    .bold()
                                                                    .padding(.bottom, 1)
                                                                HStack {
                                                                    Image(systemName: quoteValue.d > 0 ? "arrow.up.right" : "arrow.down.right")
                                                                        .foregroundColor(Double(quoteValue.d) > 0 ? .green : .red)
                                                                    Text("$\(quoteValue.d, specifier: "%.2f")")
                                                                        .font(.subheadline)
                                                                        .foregroundColor(Double(quoteValue.d) > 0 ? .green : .red)
                                                                    Text("(\(quoteValue.dp, specifier: "%.2f")%)")
                                                                        .font(.subheadline)
                                                                        .foregroundColor(Double(quoteValue.d) > 0 ? .green : .red)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .onMove { from, to in
                                                favoritesHome.move(fromOffsets: from, toOffset: to)
                                                saveOrder()
                                            }
                                            .onDelete(perform: delete)
                                        }
                                    }
                                }
                                HStack {
                                    Spacer()
                                    Link("Powered by Finnhub.io", destination: URL(string: "https://www.finnhub.io")!)
                                        .foregroundStyle(.secondary)
                                        .font(.subheadline)
                                    Spacer()
                                }
                            }
                        }
                        
                    }
                    .navigationTitle("Stocks")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            EditButton()
                        }
                    }
                    .searchable(text: $viewModel.searchTerm)
                } else {
                    ProgressView {
                        Text("Fetching Data...")
                    }
                    .background(Color.white)
                    .navigationTitle("Stocks")
                }
            }
            .background(Color(red: 0.9453, green: 0.9453, blue: 0.9453))
            .onAppear {
                favoritesOrdered = false
                getWallet()
                getFavorites()
                fetchPortfolioData()
            }
            .onDisappear {
                self.timer.upstream.connect().cancel()
            }
        }
    }
    
    private func savePortfolioOrder() {
        savedPortfolioOrder = portfoliosHome.map { $0.stock }
        UserDefaults.standard.set(savedPortfolioOrder, forKey: "SavedPortfolioOrder")
    }

    private func loadPortfolioOrder() {
        guard let savedOrder = UserDefaults.standard.object(forKey: "SavedPortfolioOrder") as? [String] else { return }
        var orderedPortfolios = [PortfolioHome]()
        for ticker in savedOrder {
            if let portfolio = portfoliosHome.first(where: { $0.stock == ticker }) {
                orderedPortfolios.append(portfolio)
            }
        }
        let existingTickers = Set(savedOrder)
        let newPortfolios = portfoliosHome.filter { !existingTickers.contains($0.stock)
        }
        orderedPortfolios.append(contentsOf: newPortfolios)
        portfoliosHome = orderedPortfolios
    }

    private func updateQuotes() {
        // Update quotes for portfolio
        DispatchQueue.main.async {
            for key in quote.keys {
                getQuote(ticker: key) { quote in
                }
            }
        }
    }

    private func fetchPortfolioData() {
        portfolio = []
        portfoliosHome = []
        getPortfolio {stocks in
            guard let stocks = stocks, !stocks.isEmpty else {
                portfolioLoaded = true
                return
            }
            portfolio = stocks
            let group = DispatchGroup()
            var quotes: [Double] = Array(repeating: 0.0, count: stocks.count)

            for (index, stock) in stocks.enumerated() {
                group.enter()
                getQuote(ticker: stock.stock) { quote in
                    defer { group.leave() }
                    if let quote = quote {
                        let quantity = Double(stock.quantity)
                        quotes[index] = quote.c * quantity
                        let portfolioHome: PortfolioHome =
                        PortfolioHome(
                            _id: stock._id,
                            stock: stock.stock, price: stock.price,
                            quantity: stock.quantity,
                            stockDescription: stock.stockDescription,
                            c: quote.c, d: quote.d,
                            dp: quote.dp
                            )
                        portfoliosHome.append(portfolioHome)
                    }

                }
            }

            group.notify(queue: .main) {
                let totalStocksPrice = quotes.reduce(0, +)
                stockValue = totalStocksPrice
                loadPortfolioOrder()
                portfolioLoaded = true
            }
        }
    }

    private func getWallet() {
        if let apiURL = URL(string: "http://127.0.0.1:3000/getWallet") {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                let group = DispatchGroup()
                group.enter()
                if let walletData = data {
                    wallet = String(data: walletData, encoding: .utf8) ?? "Error"
                    print(wallet)
                    group.leave()
                }
                group.notify(queue: .main) {
                    walletDataFetched = true
                    print("walletDataFetched")
                }
            }.resume()
        }
    }

    private func saveOrder() {
        savedOrder = favoritesHome.map { $0.ticker }
        UserDefaults.standard.set(savedOrder, forKey: "SavedFavoritesOrder")
    }

    private func loadFavorites() {
        let loadedFavorites = favoritesHome

        if let savedOrder = UserDefaults.standard.object(forKey: "SavedFavoritesOrder") as? [String] {
            favoritesHome = savedOrder.compactMap { orderTicker in
                print("savedTicker = \(orderTicker)")
                return loadedFavorites.first { $0.ticker == orderTicker }
            }
            let newFavorites = loadedFavorites.filter { favorite in
                !savedOrder.contains(favorite.ticker)
            }
            favoritesHome.append(contentsOf: newFavorites)
        } else {
            favoritesHome = loadedFavorites
        }
        favoritesOrdered = true
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

    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let favorite = favoritesHome[index]
            print("Deleting: \(favorite.ticker) with description: \(favorite.stockDescription)")
            removeFromFavorites(ticker: favorite.ticker)
        }
        favoritesHome.remove(atOffsets: offsets)
    }

    private func removeFromFavorites(ticker: String) {
        if let apiURL = URL(string: "http://127.0.0.1:3000/removeFromWatchlist?ticker=\(ticker)") {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if data != nil {
                    print("Removed from favorites")
                }
            }.resume()
        }
    }
    
    private func getFavorites() {
        favorites = []
        favoritesHome = []
        if let apiURL = URL(string: "http://127.0.0.1:3000/getWatchlist") {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                favoritesLoaded = true
                print("favoritesLoaded")
                if let watchlistData = data, let watchlistFromAPI = try? JSONDecoder().decode([Favorite].self, from: watchlistData) {
                    DispatchQueue.main.async {
                        favorites = watchlistFromAPI
                    }
                    let group = DispatchGroup()
                    for favorite in watchlistFromAPI {
                        group.enter()
                        getQuote(ticker: favorite.ticker) { quote in
                            DispatchQueue.main.async {
                                if let q = quote {
                                    let favoriteHome = FavoriteHome(_id: favorite._id, ticker: favorite.ticker, stockDescription: favorite.stockDescription, c: q.c, dp: q.dp, d: q.d)
                                    favoritesHome.append(favoriteHome)
                                }
                                group.leave()
                            }
                        }
                    }
                    group.notify(queue: .main) {
                        loadFavorites()
                    }
                }
            }.resume()
        }
    }

    private func getQuote(ticker: String, completion: @escaping (Quote?) -> Void) {
        let apiURL = URL(string: "http://127.0.0.1:3000/company/quote?ticker=" + ticker)
            URLSession.shared.dataTask(with: apiURL!) {data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(Quote.self, from: data)
                        quote[ticker] = decodedData
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
    HomeView()
        .environmentObject(ViewModel())
        .environmentObject(PortfolioViewModel())
}
