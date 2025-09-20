//
//  ContentView.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 28/08/2025.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    @StateObject var store: PostStore = PostStore()
    
    @State var addPost: Bool = false
    @State var postToChange: Post? = nil
    
    
    @State var postForReminder: Post?
    @State var postToChangeReminder: Post?
    
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(store.posts) { post in
                    PostView(post: post,
                             onTap: {
                        postForChange in postToChange = postForChange
                    },
                             onBellTap: {
                        postToChangeReminder = post
                    }
                    )
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 4)
                    .swipeActions(edge: .leading) {
                        Button {
                            postForReminder = post
                        } label: {
                            Label("Reminder", systemImage: "bell")
                        }
                        .tint(.blue)
                    }
                    
                }
                .onDelete(perform: deleteItems)
            }
            .refreshable {
                print ("Refreshing")
                await store.fetchPosts()
            }
            .listStyle(PlainListStyle())
            .background(
                LinearGradient(
                    colors: [Color.white, Color(.systemGray5)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
            .task { await store.fetchPosts() }
            
            .sheet(item: $postToChange) { post in
                EditPostView(post: post, title: post.title, content: post.content) { newTitle, newContent in
                    var updated = post
                    updated.title = newTitle
                    updated.content = newContent
                    Task { await store.updatePost(updated) }
                    postToChange = nil
                }
            }
            
            .sheet(isPresented: $addPost) {
                AddPostView { title, content in
                    let newPost = Post(title: title, content: content)
                    Task { await store.addPost(newPost) }
                    addPost = false
                }
            }
            .sheet(item: $postForReminder) { postForReminder in
                AddAlertView(post: postForReminder) { post, date in
                    Task {await store.addReminder(post: post, date: date)}
                }
            }
            .sheet(item: $postToChangeReminder) { postToChangeReminder in
                UpdateAlertView(post: postToChangeReminder) { post, date in
                    Task { await store.updateReminder(post: post, date: date)}
                }
            }
            
            .navigationTitle("Posts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addPost.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        appState.token = nil
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.backward.circle.fill")
                                .foregroundColor(.red)
                            Text("Logout")
                                .bold()
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            
        }
        
    }
        
        func deleteItems(at offsets: IndexSet) {
            for offset in offsets {
                Task { await store.deletePost(store.posts[offset]) }
            }
        }
        
        
    
}
