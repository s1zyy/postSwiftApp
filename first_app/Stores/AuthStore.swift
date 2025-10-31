
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

class AuthStore: ObservableObject {
    static let shared: AuthStore = AuthStore()
    private let baseURL: String
    private let appState: AppState = AppState.shared
    private let networkHelper: NetworkHelper = NetworkHelper.shared

    
    
    init () {
        guard let url = Secrets.shared.localhost else {
            fatalError("Base URL not set")
        }
        self.baseURL = url
    }
    
    @MainActor
    func login(username: String, password: String) async {
        let endpoint = "\(baseURL)/auth/login"
        let body = ["username": username, "password": password]
        let decoder = JSONHelper.makeDecoder()
        
        do {
            let request = try networkHelper.makeRequest(endpoint: endpoint, method: "POST", body: body)

            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try decoder.decode(AuthResponse.self, from: data)
            
            AppState.shared.token = response.token
            AppState.shared.currentUser = response.user
                    
        } catch {
            print("Login error: \(error)")
        }
    }

    @MainActor
    func signUp(email: String, password: String) async{
        
        let endpoint = "\(baseURL)/users"
        let user: User = User(email: email, password: password)
        do{
            let request = try networkHelper.makeRequest(endpoint: endpoint, method: "POST", body: user)
            let _: EmptyResponse = try await networkHelper.decode(request)
            await login(username: user.email, password: user.password)
        } catch {
            print("SignUp error: \(error)")
        }
    }

}
