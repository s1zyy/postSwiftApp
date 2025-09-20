
//
//  Auth.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 02/09/2025.
//

import Foundation

struct AuthResponse: Codable {
    let token: String
}



func login(username: String, password: String) async -> String? {
    guard let baseURL = Secrets.shared.baseUrlHome else {return nil }
    
    guard let url = URL(string: "\(baseURL)/auth/login") else { return nil }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body = ["username": username, "password": password]
    request.httpBody = try? JSONEncoder().encode(body)
    
    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(AuthResponse.self, from: data)
        return response.token
    } catch {
        print("Login error: \(error)")
        return nil
    }
}

func fetchPosts(token: String) async {
    guard let baseURL = Secrets.shared.baseUrlHome else { return }

    
    guard let url = URL(string: "\(baseURL)/posts") else { return }
    var request = URLRequest(url: url)
    
    request.setValue("Bearer \(token)" , forHTTPHeaderField: "Authorization")
    
    do {
        let (_, _) = try await URLSession.shared.data(for: request)
        
    } catch {
        print("Error fetching notes: \(error)")
    }
    
}
