//
//  ContentView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/8/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var favorites: [Favorite] = []
    @State var portfolio: [Portfolio] = []
    
    @State var isActive = true
    var body: some View {
        VStack {
            if isActive {
                SplashScreenView()
            } else {
                HomeView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isActive = false
            }
        }
    }
}

#Preview {
    ContentView()
}
