
//
//  Auth.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 02/09/2025.
//

import Foundation

struct AuthResponse: Codable {
    let token: String
    let user: User
}

@MainActor
func login(username: String, password: String) async {
    guard let baseURL = Secrets.shared.localhost else { return }

    let endpoint = "\(baseURL)/auth/login"
    let body = ["username": username, "password": password]
    let decoder = JSONHelper.makeDecoder()
    
    do {
        let request = try NetworkHelper.makeRequest(endpoint: endpoint, method: "POST", body: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try decoder.decode(AuthResponse.self, from: data)
        
        AppState.shared.token = response.token
        AppState.shared.currentUser = response.user
                
    } catch {
        print("Login error: \(error)")
    }
}
