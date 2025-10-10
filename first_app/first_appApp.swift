//
//  first_appApp.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 28/08/2025.
//

import SwiftUI

@main
struct first_appApp: App {
    @StateObject var appState = AppState.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                
                switch appState.currentScreen {
                case .login:
                    LoginView()
                        .environmentObject(appState)
                    
                    
                case .content:
                    ContentView()
                        .environmentObject(appState)
                    
                case .profile:
                    ProfileView()
                        .environmentObject(appState)
                    
                case .forgotPassword:
                    ForgotPasswordView()
                        .environmentObject(appState)
                    
                case .resetPassword(let email):
                    SetNewPasswordView(email: email)
                        .environmentObject(appState)
                }
            
                

            
            }

        
        }
        
    }
    
    
}
