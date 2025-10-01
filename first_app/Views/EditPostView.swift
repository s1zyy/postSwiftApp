//
//  EditPostView.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 28/08/2025.
//

import SwiftUI

struct EditPostView: View {
    let post: Post
    
    @State var title: String
    @State var content: String
    
    var editedText: ((String, String) -> Void)
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Title")
                        .font(.headline)
                    TextField("Title", text: $title)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Content")
                        .font(.headline)
                    TextField("Content", text: $content, axis: .vertical)
                        .lineLimit(3...6)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Edit Post")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        editedText(title, content)
                        dismiss()
                    } label: {
                        Text("Save")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                LinearGradient(
                                    colors: [Color.blue, Color.purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(10)
                    }
                    .disabled(title.isEmpty || content.isEmpty || (title == post.title && content == post.content))
                    .opacity(title.isEmpty || content.isEmpty || (title == post.title && content == post.content) ? 0.5 : 1.0)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Back")
                            .bold()
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}
