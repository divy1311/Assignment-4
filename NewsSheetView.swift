//
//  NewsSheetView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/11/24.
//

import SwiftUI

struct NewsSheetView: View {
    
    @State var news: News = News(source:"Yahoo", datetime:1712843218, headline:"Apple's AI iPhone Could See 5G-Like Upgrade Cycle", url:"https://finnhub.io/api/news?id=197085c750a958d4926da3993a4abe0281dfb8e8024ca63285399e64290c3f0f", summary:"Apple stock could be due for a rerating when the company comes out with its rumored AI-enabled iPhone this fall, a Wall Street analyst says.", image:"https://media.zenfs.com/en/ibd.com/887feed8169b49a4b1c84863dc15e2ed")
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Spacer()
                Image(systemName: "xmark")
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }.padding()
        VStack(alignment: .leading) {
            Text(news.source)
                .font(.title3)
                .bold()
            let date = Date(timeIntervalSince1970: Double(news.datetime))
            Text(date, style: .date)
                .font(.caption)
                .foregroundStyle(.secondary)
            Divider()
            Text(news.headline)
                .font(.title3)
                .bold()
            Text(news.summary)
                .font(.caption)
            HStack {
                Text("For more details click")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Link("here", destination: (URL(string: news.url)!))
                    .font(.caption)
            }
            HStack {

                let xLink = "https://twitter.com/intent/tweet?text=" + news.headline + " " + news.url
                if let encodedLink = xLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    Link(destination: URL(string: encodedLink)!) {
                        Image("x-logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45)
                    }
                }
                let fbLink = "https://www.facebook.com/sharer/sharer.php?u=" + news.url
                if let encodedLink = fbLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    Link(destination: URL(string: encodedLink)!) {
                        Image("fb-logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45)
                    }
                }
            }
            .padding(.top, 10)
        }
        .padding()
        Spacer()
    }
}

#Preview {
    NewsSheetView()
}
