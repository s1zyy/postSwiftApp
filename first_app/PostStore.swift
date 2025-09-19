//
//  PostStore.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 29/08/2025.
//

import SwiftUI

class PostStore: ObservableObject {
    
    private let appState: AppState = AppState.shared

    @Published var posts: [Post] = []
    
    private let baseURL: String
    
    init() {
        guard let url = Secrets.shared.baseUrlHome else {
            fatalError("Base URL not set")
        }
        self.baseURL = url
        
    }
    
    
    
    
    @MainActor
    func fetchPosts() async {


        
        guard let url = URL(string: "\(baseURL)/posts") else { return }
        
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = appState.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON:\n\(jsonString)")
            }
            
            
            if let httpResponse = response as? HTTPURLResponse {
                guard 200..<300 ~= httpResponse.statusCode else {
                    print("Server error: \(httpResponse.statusCode)")
                    return
                }
            }
            
            if(data.isEmpty){
                return
            }
            
            let decoder : JSONDecoder = JSONDecoder()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            
            let decoded = try decoder.decode([Post].self, from: data)
            
            
            
            
            posts = decoded
            
            
                                
        } catch {
            print("Error fetching data:" , error)
        }
    }
    
    @MainActor
    func addPost(_ post: Post) async {
        guard let url = URL(string: "\(baseURL)/posts") else { return }
        guard let token = appState.token else {
            print("No token found")
            return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = try? JSONEncoder().encode(post)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let newPost = try JSONDecoder().decode(Post.self, from: data)
            posts.append(newPost)
        
            
        } catch {
            print("Error adding post:", error)
        }
    }
    @MainActor
    func updatePost(_ post: Post) async {
        guard let id = post.id else {
            return
        }
        

        guard let url = URL(string: "\(baseURL)/posts/\(id)") else { return }
        guard let token = appState.token else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        encoder.dateEncodingStrategy = .formatted(formatter)
        decoder.dateDecodingStrategy = .formatted(formatter)
        request.httpBody = try? encoder.encode(post)
        
        print(post.reminder!)
        
        do {
            let (data , _) = try await URLSession.shared.data(for: request)
            
            let updatedPost = try decoder.decode(Post.self, from: data)
            
            if let index = posts.firstIndex(where: { $0.id == updatedPost.id }) {
                        posts[index] = updatedPost
                    }
            
            
            
            
        } catch {
            print( "Error updating post:", error)
        }
    }
    
    @MainActor
    func deletePost(_ post: Post) async {
        
        let id = post.id!
        

        guard let url = URL(string: "\(baseURL)/posts/\(id)") else { return }
        guard let token = appState.token else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue( "application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        //request.httpBody = try? JSONEncoder().encode(post)
        
        
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            posts.removeAll { $0.id == id }
        } catch {
            print("Error deleting post:", error)
        }
    }
    
    @MainActor
    func addReminder(post: Post, date: Date) async {
    
        
        guard let url = URL(string: "\(baseURL)/reminder") else { return }
        guard let token = appState.token else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue( "application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        var updatedPost = post;
        
        var reminder = Reminder(reminderTime: date, completed: false)
        updatedPost.reminder = reminder;

        let encoder = JSONEncoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        encoder.dateEncodingStrategy = .formatted(formatter)
        request.httpBody = try? encoder.encode(updatedPost)
        print("request was builded")
        do {
            
            let (_, _) = try await URLSession.shared.data(for: request)
            
            //updatedPost = try JSONDecoder().decode(Post.self, from: data)
            
            if let index = posts.firstIndex(where: { $0.id == updatedPost.id }) {
                posts[index] = updatedPost
            }
            
        } catch {
            print("Error adding reminder:", error)
        }

        
    }
    
    
}

