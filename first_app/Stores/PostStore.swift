//
//  PostStore.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 29/08/2025.
//

import SwiftUI

class PostStore: ObservableObject {
    
    private let appState: AppState = AppState.shared

    static let shared: PostStore = PostStore()
    private let decoder = JSONHelper.makeDecoder()
    
    private let baseURL: String
    
    init() {
        guard let url = Secrets.shared.localhost else {
            fatalError("Base URL not set")
        }
        self.baseURL = url
        
    }
    
    
    
    
    @MainActor
    func fetchPosts() async {

        let endpoint = "\(baseURL)/posts"
        
        do {
            let request = try NetworkHelper.makeRequest(endpoint: endpoint, token: appState.token, method: "GET")

            let (data, response) = try await URLSession.shared.data(for: request)
            
            
            if let httpResponse = response as? HTTPURLResponse {
                guard 200..<300 ~= httpResponse.statusCode else {
                    print("Server error: \(httpResponse.statusCode)")
                    return
                }
            }
            
            if(data.isEmpty){
                return
            }
            
       
            let decoded = try decoder.decode([Post].self, from: data)
            
            appState.posts = decoded
                                
        } catch {
            print("Error fetching data:" , error)
        }
    }
    
    @MainActor
    func addPost(_ post: Post) async {
        let endpoint = "\(baseURL)/posts"
        do {
            let request = try NetworkHelper.makeRequest(endpoint: endpoint, token: appState.token, method: "POST", body: post)

            let (data, _) = try await URLSession.shared.data(for: request)
            if let bodyString = String(data: data, encoding: .utf8) {
                print("Response body:", bodyString) 
            }
            let newPost = try decoder.decode(Post.self, from: data)//
            appState.posts.append(newPost)
        
            
        } catch {
            print("Error adding post:", error)
        }
    }
    @MainActor
    func updatePost(_ post: Post) async {
                
        let endpoint = "\(baseURL)/posts/\(post.id!)"
            
        do {
            let request = try NetworkHelper.makeRequest(endpoint: endpoint, token: appState.token, method: "PUT", body: post)

            let (data , _) = try await URLSession.shared.data(for: request)
            
            let updatedPost = try decoder.decode(Post.self, from: data)
            
            if let index = appState.posts.firstIndex(where: { $0.id == updatedPost.id }) {
                    appState.posts[index] = updatedPost
                    }
        } catch {
            print( "Error updating post:", error)
        }
    }
    
    @MainActor
    func deletePost(_ post: Post) async {
        let endpoint = "\(baseURL)/posts/\(post.id!)"
        
        do {
            let request = try NetworkHelper.makeRequest(endpoint: endpoint, token: appState.token, method: "DELETE")
            let (_, _) = try await URLSession.shared.data(for: request)
            appState.posts.removeAll { $0.id == post.id! }
        } catch {
            print("Error deleting post:", error)
        }
    }
}
