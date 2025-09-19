//
//  PostView.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 28/08/2025.
//

import SwiftUI

struct PostView: View {
    
    @ObservedObject var post: Post
    var onTap: ((Post) -> Void)?
    var onBellTap: (() -> Void)?
    
    var body: some View {
        Button(action: {
            onTap?(post)
        }) {
            HStack {
            
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
                Text(post.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray6))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
            )
                
            if post.reminder != nil  {
                var reminder = post.reminder!
                
                Button(action: {
                    onBellTap?()
                }) {
                    Image(systemName: reminder.completed ? "bell.slash.fill" : "bell.fill")
                        .foregroundColor(reminder.completed ? .gray : .blue)
                }
                }
        }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
