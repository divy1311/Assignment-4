//
//  Assignment_4App.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/8/24.
//

import SwiftUI

@main
struct Assignment_4App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ViewModel())
                .environmentObject(PortfolioViewModel())
        }
    }
}
