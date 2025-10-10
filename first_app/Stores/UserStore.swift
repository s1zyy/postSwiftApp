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
    
    @MainActor
    func requestPasswordReset(_ email: String) async -> Bool{ 
        let url = URL(string: "\(baseURL)/users/reset-password/request")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let encoder = JSONHelper.makeEncoder()
        
        request.httpBody = try! encoder.encode(["email": email])
        
        do{
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let check = try? JSONDecoder().decode(TrueFalseResponse.self, from: data) {
                print ("Success: \(check)")
                return check.check
            }
        } catch {
            print("Error updating user name: " , error)
            return false
        }
        return false
    }
    
    @MainActor
    func sendPasswordCode(_ email: String, _ code: String) async -> Bool {
        let url = URL(string: "\(baseURL)/users/reset-password/confirm")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let encoder = JSONHelper.makeEncoder()
        let confirmCodeRequest = ConfirmCodeRequest(email: email, code: code)
        request.httpBody = try! encoder.encode(confirmCodeRequest)
        
        do {
            let(data, _) = try await URLSession.shared.data(for: request)
            
            if let check = try? JSONDecoder().decode(TrueFalseResponse.self, from: data) {
                return check.check
            }
        } catch {
            print(error)
            return false
        }
        return false
    }
    
    @MainActor
    func updatePassword(_ email: String, _ password: String) async {
        let url = URL(string: "\(baseURL)/users/reset-password/update")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONHelper.makeEncoder()
        let decoder = JSONHelper.makeDecoder()
        let updatePasswordRequest = UpdatePasswordRequest(email: email, password: password)
        request.httpBody = try! encoder.encode(updatePasswordRequest)
        
        do {
            let(data, _) = try await URLSession.shared.data(for: request)
            
            if let authResponse = try? decoder.decode(AuthResponse.self, from: data) {
                appState.currentUser = authResponse.user
                appState.token = authResponse.token
                appState.currentScreen = .content
            }
        } catch {
            print(error)
        }
    }
}
