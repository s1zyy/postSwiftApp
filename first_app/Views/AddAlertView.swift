//
//  AddAlertView.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 10/09/2025.
//

import SwiftUI

struct AddAlertView: View {
    
    let post: Post
    var onSave: (Post, Date) -> Void
    

    
    
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
        VStack(spacing: 20) {
            
            Text("Set Reminder for \(post.title)")
                .font(.headline)
            
            DatePicker("Select Date & Time", selection: $selectedDate)
                .datePickerStyle(.graphical)
            
            Button("Save Reminder") {
                
                let date = selectedDate
                onSave(post, date)
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .bold()
                        .foregroundColor(.red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                }
                
            }
        }
    }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct UpdateAlertView: View {
    
    var post: Post
    var onSave: (Post, Date) -> Void

    
    @Environment(\.dismiss) var dismiss
    
    @State var selectedDate = Date()
    
    init(post: Post, onSave: @escaping (Post, Date) -> Void) {
        self.post = post
            self.onSave = onSave
            _selectedDate = State(initialValue: post.reminder?.reminderTime ?? Date())
        }
    var body: some View {
        NavigationStack {
        VStack(spacing: 20) {
            
            Text("Update Reminder for \(post.title)")
                .font(.headline)
            
            DatePicker("Select Date & Time", selection: $selectedDate)
                .datePickerStyle(.graphical)
            
            Button("Save Reminder") {
                
                let date = selectedDate
                onSave(post, date)
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .bold()
                        .foregroundColor(.red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task { await ReminderStore().deleteReminder(post: post) }
                    dismiss()
                } label: {
                    Text("Delete")
                        .bold()
                        .foregroundColor(.red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                }
            }

        }
    }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

