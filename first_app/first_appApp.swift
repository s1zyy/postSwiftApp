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
                
                if appState.currentScreen == .login {
                    LoginView()
                        .environmentObject(appState)
                } else if appState.currentScreen == .content {
                    ContentView()
                        .environmentObject(appState)
                } else if appState.currentScreen == .profile {
                    ProfileView()
                        .environmentObject(appState)
                }
            
            }

        
        }
        
    }
    
    
}
