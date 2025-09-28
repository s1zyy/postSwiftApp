
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
    
    guard let url = URL(string: "\(baseURL)/auth/login") else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body = ["username": username, "password": password]
    
    let encoder = JSONHelper.makeEncoder()
    
    request.httpBody = try? encoder.encode(body)
    
    let decoder = JSONHelper.makeDecoder()
    
    
    
    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try decoder.decode(AuthResponse.self, from: data)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Received JSON:\n\(jsonString)")
        }
        
        AppState.shared.token = response.token
        AppState.shared.currentUser = response.user
        
        print("Current User: \(AppState.shared.currentUser)")
        
    } catch {
        print("Login error: \(error)")
    }
}

func fetchPosts(token: String) async {
    guard let baseURL = Secrets.shared.localhost else { return } // да но я не знаю от куда мне того юзера достать. то на беке

    
    guard let url = URL(string: "\(baseURL)/posts") else { return }
    var request = URLRequest(url: url)
    
    request.setValue("Bearer \(token)" , forHTTPHeaderField: "Authorization")
    
    do {
        let (_, _) = try await URLSession.shared.data(for: request)
        
    } catch {
        print("Error fetching notes: \(error)")
    }
    
}
