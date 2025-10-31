//
//  ToastView.swift
//  PostApp
//
//  Created by Vladyslav Savkiv on 19/10/2025.
//

import SwiftUI

struct ToastView: View {
    let message: String
    var body: some View {
        Text(message)
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.red.opacity(0.9))
            .cornerRadius(10)
            .shadow(radius: 5)
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.easeInOut(duration: 0.3), value: message)
    }
}

extension View {
    func toast(_ message: String?) -> some View {
        ZStack {
            self
            
            if let message = message {
                VStack{
                    ToastView(message: message)
                        .padding(.top, 50)
                    Spacer()
                    
                }
                .zIndex(9999)
            }
        }
    }
    
}
