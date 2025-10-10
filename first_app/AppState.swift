//
//  AppState.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 02/09/2025.
//


import Foundation
import SwiftUI
import Combine


class AppState: ObservableObject {
    
    enum Screen {
        case login, content, profile, forgotPassword, resetPassword(email: String)
        }
    
    static let shared = AppState()
    @Published var deviceToken: String? = nil
    
    @Published var currentScreen: Screen = .login
    
    @Published var posts: [Post] = []
    
    @Published var currentUser: User? = nil
    
    @Published var token: String? {
        didSet {
            currentScreen = (token == nil) ? .login : .content
            }
        }
    
    
    
    private init() {}
}
