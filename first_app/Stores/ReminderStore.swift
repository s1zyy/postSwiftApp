//
//  ReminderStore.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 23/09/2025.
//

import SwiftUI

class ReminderStore: ObservableObject {
    
    private let appState: AppState = AppState.shared
    static let shared: ReminderStore = ReminderStore()
    private let baseURL: String
    
    init() {
        guard let url = Secrets.shared.localhost else {
            fatalError("Base URL not set")
        }
        self.baseURL = url
    }
    
    @MainActor
    func addReminder(post: Post, date: Date) async {
            
        let endpoint = "\(baseURL)/reminder"
        let reminder = Reminder(reminderTime: date, completed: false)
        post.reminder = reminder;

        do {
            let request = try NetworkHelper.makeRequest(endpoint: endpoint, token: appState.token, method: "POST", body: post)
            
            let (_, _) = try await URLSession.shared.data(for: request)
                        
            if let index = appState.posts.firstIndex(where: { $0.id == post.id }) {
                appState.posts[index] = post
            }
        } catch {
            print("Error adding reminder:", error)
        }
    }
    
    @MainActor
    func updateReminder(post: Post, date: Date) async {
        
        
        let postId = post.id!
        let endpoint = "\(baseURL)/reminder/\(postId)"
        post.reminder?.reminderTime = date
        
        do {
            let request = try NetworkHelper.makeRequest(endpoint: endpoint, token: appState.token, method: "PUT", body: post)

            let (_, _) = try await URLSession.shared.data(for: request)
                        
            if let index = appState.posts.firstIndex(where: { $0.id == postId }) {
                appState.posts[index] = post
            }
        } catch {
            print("Error adding reminder:", error)
        }
    }
    
    @MainActor
    func deleteReminder(post: Post) async {
        let postId = post.id!
        let endpoint = "\(baseURL)/reminder/\(postId)"
        
        do {
            let request = try NetworkHelper.makeRequest(endpoint: endpoint, token: appState.token, method: "DELETE", body: post)

            let (_ , _) = try await URLSession.shared.data(for: request)
            
            post.reminder = nil
            
            if let index = appState.posts.firstIndex(where: { $0.id == postId }) {
                appState.posts[index] = post
            }
        } catch {
            print("Error deleting reminder: ", error)
        }
    }
}
