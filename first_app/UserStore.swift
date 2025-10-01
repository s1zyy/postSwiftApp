//
//  UserStore.swift
//  PostApp
//
//  Created by Vladyslav Savkiv on 28/09/2025.
//

import SwiftUI

class UserStore: ObservableObject {
    
    private let appState: AppState = AppState.shared

    static let shared: UserStore = UserStore()
    private let baseURL: String
    
    init() {
        guard let url = Secrets.shared.localhost else {
            fatalError("Base URL not set")
        }
        self.baseURL = url
        
    }
    
    
    @MainActor
    func changeName(_ userName: String) async {
        
        let userId = appState.currentUser?.id ?? 0
        
        var url = URL(string: "\(baseURL)/users/\(userId)/name")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = appState.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let encoder = JSONHelper.makeEncoder()
        
        request.httpBody = try! encoder.encode(["username": userName])
        
        do{
            let (_, _) = try await URLSession.shared.data(for: request)
            appState.currentUser?.username = userName
        } catch {
            print("Error updating user name: " , error)
        }

        
        
    }
    
    @MainActor
    func changeBirthDate(_ birthDate: Date) async {
        
        let userId = appState.currentUser?.id ?? 0
        
        var url = URL(string: "\(baseURL)/users/\(userId)/birthdate")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = appState.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let encoder = JSONHelper.makeEncoder()
        request.httpBody = try! encoder.encode(["birthDate": birthDate])
        do{
            let (_, _) = try await URLSession.shared.data(for: request)
            appState.currentUser?.birthDate = birthDate
        } catch {
            print("Error updating user name: " , error)
        }
    }
}
