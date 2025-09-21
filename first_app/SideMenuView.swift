//
//  SideMenuView.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 20/09/2025.
//


import SwiftUI

public struct SideMenuView: View {
    
    @EnvironmentObject var appState: AppState

    @State private var showLogoutConfirmation = false
    
    public var body: some View {
       
        VStack(alignment: .leading) {
            Button("Profile") {
                appState.currentScreen = .profile
                
            }
                .font(.headline)
            Divider()
            Button {
                showLogoutConfirmation = true
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.backward.circle.fill")
                        .foregroundColor(.red)
                    Text("Logout")
                        .bold()
                        .foregroundColor(.red)
                }
            }
            .confirmationDialog("Are you sure you want to log out?",
                                isPresented: $showLogoutConfirmation,
                                titleVisibility: .visible) {
                Button("Log Out", role: .destructive) {
                    appState.token = nil
                }
                Button("Cancel", role: .cancel) { }
                
            }
            
            
            Spacer()
            
        }
        .padding(.top, 80)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .shadow(radius: 5)
    }
}
