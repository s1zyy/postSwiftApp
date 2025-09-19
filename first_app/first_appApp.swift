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
            
            if let _ = appState.token{
                ContentView()
                    .environmentObject(appState)
                    .preferredColorScheme(.light)
            } else {
                LoginView()
                    .environmentObject(appState)
                    .preferredColorScheme(.light)
            }
            
            
            
        }
    }
    
    
}
