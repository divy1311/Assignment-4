//
//  ToastView.swift
//  Assignment-4
//
//  Created by Divyansh Khatri on 4/12/24.
//

import SwiftUI

struct ToastView: View {
    var message: String
    
    var body: some View {
        Text(message)
            .padding(.vertical, 28).padding(.horizontal, 45)
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(40)
            .shadow(radius: 10)
            .padding(.top, 20)
    }
}

#Preview {
    ToastView(message: "Please enter a valid amount")
}
