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
    
        
        guard let url = URL(string: "\(baseURL)/reminder") else { return }
        guard let token = appState.token else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue( "application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        

        
        var reminder = Reminder(reminderTime: date, completed: false)
        post.reminder = reminder;

        let encoder = JSONHelper.makeEncoder()
        request.httpBody = try? encoder.encode(post)
        print("request was builded")
        do {
            
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
        guard let url = URL(string: "\(baseURL)/reminder/\(postId)") else { return }
        guard let token = appState.token else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue( "application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        
        post.reminder?.reminderTime = date
        
        let encoder = JSONHelper.makeEncoder()
        
        request.httpBody = try? encoder.encode(post)
        
        do {
            
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
        guard let postId = post.id else {
            print("Post has no ID, cannot delete reminder")
                    return
        }
        
        guard let id = post.id else {
            print("Post has no ID, cannot delete reminder")
            return
        }
        guard let url = URL(string: "\(baseURL)/reminder/\(id)") else { return }
        print(url)
        guard let token = appState.token else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue( "application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        let encoder = JSONHelper.makeEncoder()
        request.httpBody = try? encoder.encode(post)
        
        
        
        do {
            
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
