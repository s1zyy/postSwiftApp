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
    private let networkHelper: NetworkHelper = NetworkHelper.shared
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
        guard let postId = post.id else {
            networkHelper.showTemporaryErrorMessage("Post has no ID")
            return
        }
        let newReminderRequest: CreateReminderRequest = CreateReminderRequest(reminderTime: date, postId: postId)
        do {
            let request = try networkHelper.makeRequest(endpoint: endpoint, token: appState.token, method: "POST", body: newReminderRequest)
            
            let newReminder: Reminder = try await networkHelper.decode(request)
            post.reminder = newReminder
            updatePost(post)
            

        } catch {
            print("Error adding reminder:", error)
        }
    }
    
    @MainActor
    func updateReminder(post: Post, date: Date) async {
        
        
        let postId = post.id!
        let endpoint = "\(baseURL)/reminder/\(postId)"
        let reminder = post.reminder!
        reminder.reminderTime = date
        
        do {
            let request = try networkHelper.makeRequest(endpoint: endpoint, token: appState.token, method: "PUT", body: reminder)
            
            let newReminder: Reminder = try await networkHelper.decode(request)
            post.reminder = newReminder
            updatePost(post)

        } catch {
            print("Error adding reminder:", error)
        }
    }
    
    @MainActor
    func deleteReminder(post: Post) async {
        let reminder = post.reminder!
        let reminderId = reminder.id!
        let endpoint = "\(baseURL)/reminder/\(reminderId)"
        
        do {
            let request = try networkHelper.makeRequest(endpoint: endpoint, token: appState.token, method: "DELETE")

            var _ : EmptyResponse = try await networkHelper.decode(request)
            
            post.reminder = nil
            
            updatePost(post)
            
        } catch {
            print("Error deleting reminder: ", error)
        }
    }
    
    func updatePost(_ post: Post) {
        if let index = appState.posts.firstIndex(where: { $0.id == post.id }) {
            appState.posts[index] = post
        }
    }
}
