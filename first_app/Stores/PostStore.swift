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
    private let networkHelper: NetworkHelper = NetworkHelper.shared
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
            let request = try networkHelper.makeRequest(endpoint: endpoint, token: appState.token, method: "GET")

            let posts: [Post] = try await networkHelper.decode(request)
            
            appState.posts = posts
                                
        } catch {
            print("Error fetching data:" , error)
        }
    }
    
    @MainActor
    func addPost(_ post: Post) async {
        let endpoint = "\(baseURL)/posts"
        do {
            let request = try networkHelper.makeRequest(endpoint: endpoint, token: appState.token, method: "POST", body: post)
            let newPost: Post = try await networkHelper.decode(request)
            appState.posts.append(newPost)
        
            
        } catch {
            print("Error adding post:", error)
        }
    }
    @MainActor
    func updatePost(_ post: Post) async {
                
        let endpoint = "\(baseURL)/posts/\(post.id!)"
        
        guard let request = try? networkHelper.makeRequest(
            endpoint: endpoint,
            token: appState.token,
            method: "PUT",
            body: post)
        else {
            print("Failed to make request")
            return
        }
        do{
            let updatedPost: Post = try await networkHelper.decode(request)
            if let index = appState.posts.firstIndex(where: { $0.id == updatedPost.id }) {
                    appState.posts[index] = updatedPost
                    }
        } catch {
            print("Error decoding updated post: \(error)")
        }
        
    }
    
    @MainActor
    func deletePost(_ post: Post) async {
        let endpoint = "\(baseURL)/posts/\(post.id!)"
        
        do {
            let request = try networkHelper.makeRequest(endpoint: endpoint, token: appState.token, method: "DELETE")
            let (_, _) = try await URLSession.shared.data(for: request)
            appState.posts.removeAll { $0.id == post.id! }
        } catch {
            print("Error deleting post:", error)
        }
    }
}
