//
//  NetworkHelper.swift
//  PostApp
//
//  Created by Vladyslav Savkiv on 11/10/2025.
//


import Foundation

struct NetworkHelper {
    
    static let encoder = JSONHelper.makeEncoder()
    static let decoder = JSONHelper.makeDecoder()
    static func makeRequest(endpoint: String, token: String? = nil, method: String = "POST", body: Encodable? = nil) throws -> URLRequest {
        guard let url = URL(string: "\(endpoint)") else {
            fatalError("Invalid URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try encoder.encode(body)
        }
        return request
        
    }
}
