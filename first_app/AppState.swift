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
    
    static let shared = AppState()
    @Published var token: String? = nil
    @Published var deviceToken: String? = nil
    
    
    private init() {}
}
