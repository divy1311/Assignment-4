//
//  StockDetailView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/9/24.
//

import SwiftUI
import WebKit
import Kingfisher

struct StockDetailView: View {

    @State var ticker: String
    @State var stockDetail: StockDetail = StockDetail(country: "", currency: "", estimateCurrency: "", exchange: "", name: "AAPL Inc", ticker: "", ipo: "", marketCapitalization: 1.0, shareOutstanding: 1.0, logo: "", phone: "", weburl: "", finnhubIndustry: "")
    @State var quote: Quote = Quote(c: -100, d: -100, dp: -1000, h: -100, l: -100, o: -100, pc: -1000, t: -100)
    @State var sentiments: Sentiments = Sentiments(symbol: "AAPL", year: 1, month: 14, change: 1, mspr: 1)
    @State var title: String = ""
    @State var error: Error? = nil
    @State var viewDailyChart = true
    @State var viewHistoricalChart = false
    @State var news: [News] = []
    @State var favorites: [Favorite] = []
    @State var firstIndex = true
    @State var showDetailedNews = false
    @State private var selectedNews: News?
    @State private var addedToFavorites: Bool = false
    @State private var showToastBuy: Bool = false
    @State private var showToastSell: Bool = false
    @State private var stockDetailsFound = false
    @State private var quoteDetailsFound = false
    @State private var sentimentsDataFound = false
    @State private var newsFound = false
    @State private var favoritesFound = false
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var portfolioViewModel: PortfolioViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if stockDetailsFound && quoteDetailsFound && newsFound && sentimentsDataFound && favoritesFound {
                    VStack (alignment:.leading) {
                        if stockDetail.logo != "" {
                            HStack {
                                Text(stockDetail.name)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                KFImage(URL(string: stockDetail.logo)!)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .navigationTitle(ticker)
                            .toolbar() {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button(action: {
                                        if addedToFavorites {
                                            removeFromFavorites()
                                        } else {
                                            addToFavorites()
                                        }
                                        addedToFavorites = !addedToFavorites
                                    }) {
                                        if !addedToFavorites {
                                            Image(systemName: "plus.circle")
                                        } else {
                                            Image(systemName: "plus.circle.fill")
                                        }
                                    }
                                }
                            }
                            .padding(.leading, 35)
                            .padding(.trailing, 50)
                        }
                        HStack (alignment: .bottom) {
                            if quote.c < 0 {
                                Text("Loading quote details...")
                                    .padding(.vertical, 0)
                                    .padding(.leading)
                                    .bold()
                            } else {
                                Text("$\(quote.c, specifier: "%.2f")")
                                    .padding(.vertical, 0)
                                    .padding(.leading)
                                    .font(.largeTitle)
                                    .bold()
                                if quote.d != 0 {
                                    Image(systemName: quote.d > 0 ? "arrow.up.right" : "arrow.down.right")
                                        .foregroundColor(Double(quote.d) > 0 ? .green : .red)
                                        .padding(.bottom, 9)
                                }
                                Text("$\(quote.d, specifier: "%.2f")")
                                    .font(.headline)
                                    .foregroundColor(Double(quote.d) > 0 ? .green : .red)
                                    .padding(.bottom, 5)
                                Text("(\(quote.dp, specifier: "%.2f")%)")
                                    .font(.headline)
                                    .foregroundColor(Double(quote.d) > 0 ? .green : .red)
                                    .padding(.bottom, 5)
                            }
                        }.padding(.leading)
                        if viewDailyChart {
                            HStack {
                                Spacer()
                                WebView(url: URL(string: "http://localhost:4200/dailyChart?ticker=" + ticker)!)
                                    .onLoadStatusChanged { loading, error in
                                        if loading {
                                            print("Loading started")
                                            self.title = "Loading…"
                                        }
                                        else {
                                            print("Done loading.")
                                            if let error = error {
                                                self.error = error
                                                if self.title.isEmpty {
                                                    self.title = "Error"
                                                }
                                            }
                                            else if self.title.isEmpty {
                                                self.title = "Some Place"
                                            }
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.width, height: 420)
                                Spacer()
                            }
                        } else if viewHistoricalChart {
                            HStack {
                                Spacer()
                                WebView(url: URL(string: "http://localhost:4200/historicalChart?ticker=" + ticker)!)
                                    .onLoadStatusChanged { loading, error in
                                        if loading {
                                            print("Loading started")
                                            self.title = "Loading…"
                                        }
                                        else {
                                            print("Done loading.")
                                            if let error = error {
                                                self.error = error
                                                if self.title.isEmpty {
                                                    self.title = "Error"
                                                }
                                            }
                                            else if self.title.isEmpty {
                                                self.title = "Some Place"
                                            }
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.width, height: 420)
                                Spacer()
                            }
                        }
                        HStack {
                            Spacer()
                            VStack {
                                Button(action: {
                                    viewDailyChart = true
                                    viewHistoricalChart = false
                                }) {
                                    Image(systemName: "chart.xyaxis.line")
                                        .font(.title2)
                                        .foregroundStyle( viewDailyChart ? Color.blue : Color.gray)
                                }
                                Text("Hourly")
                                    .font(.caption)
                                    .bold()
                                    .foregroundStyle( viewDailyChart ? Color.blue : Color.gray)
                            }
                            Spacer()
                            Spacer()
                            VStack {
                                Button(action: {
                                    viewHistoricalChart = true
                                    viewDailyChart = false
                                }) {
                                    Image(systemName: "clock.fill")
                                        .font(.title2)
                                        .foregroundStyle( viewHistoricalChart ? Color.blue : Color.gray)
                                }
                                Text("Historical")
                                    .font(.caption)
                                    .bold()
                                    .foregroundStyle( viewHistoricalChart ? Color.blue : Color.gray)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        VStack {
                            Text("Portfolio")
                                .font(.title3)
                                .bold()
                        }
                        .padding(.leading, 35)
                        .padding(.top)
                        VStack {
                            if quote.c >= 0 {
                                PortfolioView(ticker: ticker, tickerName: stockDetail.name, quote: quote)
                            }
                        }
                        .padding(.vertical)
                        VStack {
                            Text("Stats")
                                .font(.title3)
                                .bold()
                        }
                        .padding(.leading, 35)
                        .padding(.vertical)
                        StatsView(ticker: ticker)
                            .padding(.leading, 35)
                        VStack {
                            Text("About")
                                .font(.title3)
                                .bold()
                        }
                        .padding(.leading, 35)
                        .padding(.top)
                        AboutView(ticker: ticker)
                            .padding(.leading, 35)
                        VStack {
                            Text("Insights")
                                .font(.title3)
                                .bold()
                        }
                        .padding(.leading, 35).padding(.vertical)
                        InsightsView(ticker: ticker, name: stockDetail.name)
                            .padding(.leading, 35)
                            .padding(.bottom)
                        HStack {
                            Spacer()
                            WebView(url: URL(string: "http://localhost:4200/recommendation?ticker=" + ticker)!)
                                .onLoadStatusChanged { loading, error in
                                    if loading {
                                        print("Loading started")
                                        self.title = "Loading…"
                                    }
                                    else {
                                        print("Done loading.")
                                        if let error = error {
                                            self.error = error
                                            if self.title.isEmpty {
                                                self.title = "Error"
                                            }
                                        }
                                        else if self.title.isEmpty {
                                            self.title = "Some Place"
                                        }
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width, height: 420)
                                .padding(.leading, -15)
                            Spacer()
                        }
                        WebView(url: URL(string: "http://localhost:4200/historicalEPS?ticker=" + ticker)!)
                            .onLoadStatusChanged { loading, error in
                                if loading {
                                    print("Loading started")
                                    self.title = "Loading…"
                                }
                                else {
                                    print("Done loading.")
                                    if let error = error {
                                        self.error = error
                                        if self.title.isEmpty {
                                            self.title = "Error"
                                        }
                                    }
                                    else if self.title.isEmpty {
                                        self.title = "Some Place"
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width, height: 420)
                            .padding(.trailing)
                        
                            .padding(.trailing)
                        VStack {
                            Text("News")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .padding(.leading, 35)
                        }
                        if(news.count > 0) {
                            VStack {
                                ForEach(news.indices.prefix(20), id: \.self) { i in
                                    if i == 0 {
                                        VStack (alignment: .leading){
                                            KFImage(URL(string: news[i].image)!)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(height: 200)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                            
                                            HStack {
                                                Text(news[i].source)
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                                    .bold()
                                                let date = Date(timeIntervalSince1970: Double(news[i].datetime))
                                                let currentDate = Date()
                                                let components = Calendar.current.dateComponents([.hour, .minute], from: date, to: currentDate)
                                                let hours = components.hour ?? 0
                                                let minutes = components.minute ?? 0
                                                
                                                Text("\(hours) hr, \(minutes) min")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                            }
                                            Text(news[i].headline)
                                                .font(.headline)
                                                .bold()
                                            Divider()
                                        }
                                        .onTapGesture {
                                            showDetailedNews = true
                                            selectedNews = news[i]
                                        }
                                        .padding()
                                    } else  {
                                        HStack(alignment: .top) {
                                            VStack (alignment: .leading) {
                                                HStack {
                                                    Text(news[i].source)
                                                        .font(.caption)
                                                        .foregroundStyle(.secondary)
                                                        .bold()
                                                    let date = Date(timeIntervalSince1970: Double(news[i].datetime))
                                                    let currentDate = Date()
                                                    let components = Calendar.current.dateComponents([.hour, .minute], from: date, to: currentDate)
                                                    let hours = components.hour ?? 0
                                                    let minutes = components.minute ?? 0
                                                    if minutes > 0 {
                                                        Text("\(hours) hr, \(minutes) min")
                                                            .font(.caption)
                                                            .foregroundStyle(.secondary)
                                                    } else {
                                                        Text("\(hours) hr")
                                                            .font(.caption)
                                                            .foregroundStyle(.secondary)
                                                    }
                                                }
                                                Text(news[i].headline)
                                                    .font(.headline)
                                                    .bold()
                                            }
                                            Spacer()
                                            Spacer()
                                            KFImage(URL(string: news[i].image)!)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                        .padding()
                                        .onTapGesture {
                                            showDetailedNews = true
                                            selectedNews = news[i]
                                        }
                                    }
                                }
                            }.padding(.vertical, 0)
                                .padding(.horizontal)
                                .sheet(item: $selectedNews) { item in
                                    NewsSheetView(news: item)
                                }
                        }
                        
                    }
                }
                else {
                    VStack {
                        Spacer()
                        ProgressView("Fetching Data...")
                        Spacer()
                    }
                    .frame(minHeight: UIScreen.main.bounds.height - 200)
                }
            }.onAppear {
                getStockDetails()
                getQuoteDetails()
                getSentimentsData()
                getNews()
                getFavorites()
            }
            .overlay(
                Group {
                    if showToastBuy {
                        ToastView(message: "Adding \(ticker) to favorites")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .padding(.top)
                    } else if showToastSell {
                        ToastView(message: "Removing \(ticker) from favorites")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .padding(.top)
                    }
                }
            )
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
                        stockDetailsFound = true
                        print("Stock details found")
                    }
                }
            }.resume()
        }
    }

    private func getFavorites() {
        favorites = []
        if let apiURL = URL(string: "http://127.0.0.1:3000/getWatchlist") {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let watchlistData = data {
                    if let watchlistFromAPI =
                        try? JSONDecoder().decode([Favorite].self, from: watchlistData) {
                        favorites = watchlistFromAPI
                        DispatchQueue.main.async {
                            for favorite in favorites {
                                if favorite.ticker == ticker {
                                    addedToFavorites = true
                                    break
                                }
                            }
                            favoritesFound = true
                            print("favorites found")
                        }
                    }
                }
            }.resume()
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
                        quoteDetailsFound = true
                        print("quote details found")
                    }
                }
            }.resume()
        }
    }

    private func addToFavorites() {
        if let apiURL = URL(string: "http://127.0.0.1:3000/addToWatchlist?ticker=\(ticker)&stockDescription=\(stockDetail.name)") {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if data != nil {
                    withAnimation {
                        showToastBuy = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showToastBuy = false
                        }
                    }
                }
            }.resume()
        }
    }

    private func removeFromFavorites() {
        if let apiURL = URL(string: "http://127.0.0.1:3000/removeFromWatchlist?ticker=\(ticker)") {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if data != nil {
                    withAnimation {
                        showToastSell = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showToastSell = false
                        }
                    }
                }
            }.resume()
        }
    }

    private func getSentimentsData() {
        if let apiURL = URL(string: "http://127.0.0.1:3000/company?ticker="+ticker) {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let sentimentsData = data {
                    if let sentimentsDetailFromAPI =
                        try? JSONDecoder().decode(Sentiments.self, from: sentimentsData) {
                        sentiments = sentimentsDetailFromAPI
                    }
                }
                sentimentsDataFound = true
                print("sentiment details found")
            }.resume()
        }
    }

    private func getNews() {
        if let apiURL = URL(string: "http://127.0.0.1:3000/company/news?ticker="+ticker) {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let newsData = data {
                    if let newsDetailFromAPI =
                        try? JSONDecoder().decode([News].self, from: newsData) {
                        news = newsDetailFromAPI
                        newsFound = true
                        print("news details found")
                    }
                }
            }.resume()
        }
    }
}

#Preview {
    StockDetailView(ticker: "AAPL")
        .environmentObject(ViewModel())
        .environmentObject(PortfolioViewModel())
}
