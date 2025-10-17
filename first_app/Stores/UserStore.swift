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
    private let encoder = JSONHelper.makeEncoder()
    private let decoder = JSONHelper.makeDecoder()
    
    
    
    init() {
        guard let url = Secrets.shared.localhost else {
            fatalError("Base URL not set")
        }
        self.baseURL = url
        
    }
    
    @MainActor
    func changeName(_ userName: String) async {
        
        let userId = appState.currentUser?.id ?? 0
        
        let endpoint = "\(baseURL)/users/\(userId)/name"
        
        do{
            let request = try NetworkHelper.makeRequest(endpoint: endpoint, token: appState.token, method: "PUT", body: ["username": userName])//TODO
            let (_, _) = try await URLSession.shared.data(for: request)
            appState.currentUser?.username = userName
        } catch {
            print("Error updating user name: " , error)
        }
        
    }
    
    @MainActor
    func changeBirthDate(_ birthDate: Date) async {
        
        let userId = appState.currentUser?.id ?? 0
        
        let endpoint = "\(baseURL)/users/\(userId)/birthdate"
        
        do{
            let request = try NetworkHelper.makeRequest(endpoint: endpoint,token: appState.token, method: "PUT", body: ["birthDate": birthDate])
            let (_, _) = try await URLSession.shared.data(for: request)
            appState.currentUser?.birthDate = birthDate
        } catch {
            print("Error updating user name: " , error)
        }
    }
    
    @MainActor
    func requestPasswordReset(_ email: String) async -> Bool{ 
        let endpoint = "\(baseURL)/users/reset-password/request"
        
        do{
            let request = try NetworkHelper.makeRequest(endpoint: endpoint, method: "POST", body: ["email": email])
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let check = try? decoder.decode(TrueFalseResponse.self, from: data) {
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
        let endpoint = "\(baseURL)/users/reset-password/confirm"
        let confirmCodeRequest = ConfirmCodeRequest(email: email, code: code)
        do {
            let request = try NetworkHelper.makeRequest(endpoint: endpoint, method: "POST", body: confirmCodeRequest)
            let(data, _) = try await URLSession.shared.data(for: request)
            
            if let check = try? decoder.decode(TrueFalseResponse.self, from: data) {
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
        let endpoint = "\(baseURL)/users/reset-password/update"
        
        let updatePasswordRequest = UpdatePasswordRequest(email: email, password: password)
        
        do {
            let request = try NetworkHelper.makeRequest(endpoint: endpoint, method: "POST", body: updatePasswordRequest)
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
