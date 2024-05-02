//
//  BuySellSheetCongratulationsView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/12/24.
//

import SwiftUI

struct BuySellSheetCongratulationsView: View {
    
    @State var buy: Bool
    @State var shares: String
    @State var ticker: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            VStack {
                Spacer()
                Text("Congratulations!")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                if buy {
                    if Double(shares) == 1 {
                        Text("You have successfully bought \(shares) share of \(ticker)")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Text("You have successfully bought \(shares) shares of \(ticker)")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                } else {
                    if Double(shares) == 1 {
                        Text("You have successfully sold \(shares) share of \(ticker)")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Text("You have successfully sold \(shares) shares of \(ticker)")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                Spacer()
                    Button(action: {
                        dismiss()
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
            .foregroundStyle(Color.white)
    }
}

#Preview {
    BuySellSheetCongratulationsView(buy: true, shares: "1", ticker: "AAPL")
}
