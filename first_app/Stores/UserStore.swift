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
    private let networkHelper: NetworkHelper = NetworkHelper.shared

    
    
    
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
            let request = try networkHelper.makeRequest(endpoint: endpoint, token: appState.token, method: "PUT", body: ["username": userName])
            let newUser: User = try await networkHelper.decode(request)
            appState.currentUser?.username = newUser.username
        } catch {
            print("Error updating user name: " , error)
        }
        
    }
    
    @MainActor
    func changeBirthDate(_ birthDate: Date) async {
        
        let userId = appState.currentUser?.id ?? 0
        
        let endpoint = "\(baseURL)/users/\(userId)/birthdate"
        
        do{
            let request = try networkHelper.makeRequest(endpoint: endpoint,token: appState.token, method: "PUT", body: ["birthDate": birthDate])
            let newUser: User = try await networkHelper.decode(request)
            appState.currentUser?.birthDate = newUser.birthDate
        } catch {
            print("Error updating user name: " , error)
        }
    }
    
    @MainActor
    func requestPasswordReset(_ email: String) async -> Bool{ 
        let endpoint = "\(baseURL)/users/reset-password/request"
        
        do{
            let request = try networkHelper.makeRequest(endpoint: endpoint, method: "POST", body: ["email": email])
            let check: TrueFalseResponse = try await networkHelper.decode(request)
            
            return check.check
        } catch {
            print("Error updating user name: " , error)
            return false
        }
    }
    
    @MainActor
    func sendPasswordCode(_ email: String, _ code: String) async -> Bool {
        let endpoint = "\(baseURL)/users/reset-password/confirm"
        let confirmCodeRequest = ConfirmCodeRequest(email: email, code: code)
        do {
            let request = try networkHelper.makeRequest(endpoint: endpoint, method: "POST", body: confirmCodeRequest)
            let check: TrueFalseResponse = try await networkHelper.decode(request)
            
            return check.check
        } catch {
            print(error)
            return false
        }
    }
    
    @MainActor
    func updatePassword(_ email: String, _ password: String) async {
        let endpoint = "\(baseURL)/users/reset-password/update"
        
        let updatePasswordRequest = UpdatePasswordRequest(email: email, password: password)
        
        do {
            let request = try networkHelper.makeRequest(endpoint: endpoint, method: "POST", body: updatePasswordRequest)
            
            let authResponse: AuthResponse = try await networkHelper.decode(request)
            appState.currentUser = authResponse.user
            appState.token = authResponse.token
            appState.currentScreen = .content
            return
            
        } catch {
            print(error)
        }
    }
}
