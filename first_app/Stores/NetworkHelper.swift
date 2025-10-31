//
//  NetworkHelper.swift
//  PostApp
//
//  Created by Vladyslav Savkiv on 11/10/2025.
//


import Foundation

struct NetworkHelper {
    
    private let appState: AppState = AppState.shared
    private let encoder = JSONHelper.makeEncoder()
    private let decoder = JSONHelper.makeDecoder()
    static let shared: NetworkHelper = NetworkHelper()
    
    func makeRequest(endpoint: String, token: String? = nil, method: String, body: Encodable? = nil) throws -> URLRequest {
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
    
    @MainActor
    func decode<T: Decodable>(_ request: URLRequest) async throws -> T{
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if (200...299).contains(httpResponse.statusCode){
            
            if(data.isEmpty){
                if T.self == EmptyResponse.self{
                    return EmptyResponse() as! T
                }
                throw URLError(.zeroByteResource)
            }
            
            
             return try decoder.decode(T.self, from: data)
            
        } else {
            if let error = try? decoder.decode(ErrorReceived.self, from: data){
                showTemporaryErrorMessage(error.message)
                
            }
            throw URLError(.badServerResponse)
        }
    }
    
    func showTemporaryErrorMessage(_ message: String) {
        AppState.shared.errorMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            AppState.shared.errorMessage = nil
        }
    }
    
}
