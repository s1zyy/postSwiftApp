//
//  ProfileView.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 21/09/2025.
//


import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var username: String = ""
    @State private var birthDate: Date? = nil
    

    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Profile")
                
                Text("Name: \(username)")
                
                if let birthDate = birthDate {
                    Text("Date of birth: \(DateFormatter.localizedString(from: birthDate, dateStyle: .medium, timeStyle: .none))")
                } else {
                    Text ("No date of birth")
                }
                
                
                
                
                
                
            }
            .onAppear {
                username = appState.currentUser?.username ?? ""
                birthDate = appState.currentUser?.birthDate
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        appState.currentScreen = .content
                    } label: {
                        Text("Back")
                            .bold()
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
