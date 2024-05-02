//
//  SplashScreenView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/8/24.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("stock-logo")
                .resizable()
                .scaledToFit()
            Spacer()
        }
        .background(Color(red: 0.9453, green: 0.9453, blue: 0.9453))
    }
}

#Preview {
    SplashScreenView()
}
