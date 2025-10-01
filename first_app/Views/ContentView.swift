//
//  ContentView.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 28/08/2025.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    @StateObject var postStore: PostStore = PostStore.shared
    @StateObject var reminderStore: ReminderStore = ReminderStore.shared
    
    @State var addPost: Bool = false
    @State var postToChange: Post? = nil
    
    
    @State var postForReminder: Post?
    @State var postToChangeReminder: Post?
    @State var showMenu: Bool = false
    
    @State private var showDeleteConfirmation: Bool = false
    @State var postForDelete: Post? = nil
    
    var body: some View {
        ZStack {
        
        NavigationStack {
            List {
                ForEach($appState.posts) { $post in
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
                    .swipeActions(edge: .trailing) {
                        Button {
                            postForDelete = post
                            showDeleteConfirmation = true
                        } label:{
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .tint(.red)
                    
                }
                
            }
            .refreshable {
                print ("Refreshing")
                await postStore.fetchPosts()
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
            .task { await postStore.fetchPosts() }
            
            .sheet(item: $postToChange) { post in
                EditPostView(post: post, title: post.title, content: post.content) { newTitle, newContent in
                    var updated = post
                    updated.title = newTitle
                    updated.content = newContent
                    Task { await postStore.updatePost(updated) }
                    postToChange = nil
                }
            }
            
            .sheet(isPresented: $addPost) {
                AddPostView { title, content in
                    let newPost = Post(title: title, content: content)
                    Task { await postStore.addPost(newPost) }
                    addPost = false
                }
            }
            .sheet(item: $postForReminder) { postForReminder in
                AddAlertView(post: postForReminder) { post, date in
                    Task {await reminderStore.addReminder(post: post, date: date)}
                }
            }
            .sheet(item: $postToChangeReminder) { postToChangeReminder in
                UpdateAlertView(post: postToChangeReminder) { post, date in
                    Task { await reminderStore.updateReminder(post: post, date: date)}
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
                        withAnimation {
                            showMenu.toggle()
                        }
                        
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                    }
                }
            }
            
        }
        .confirmationDialog("Are you sure you want to delete this post?",
                            isPresented: $showDeleteConfirmation,
                             titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                if let post = postForDelete {
                    Task {
                        await postStore.deletePost(post)
                    }
                }
            }
            Button("Cancel", role: .cancel) {
                postForDelete = nil
            }
        }
            
            if showMenu {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }
                HStack ( spacing: 0) {
                    SideMenuView()
                        .environmentObject(appState)
                        .preferredColorScheme(.light)
                        .frame(width: min(300, UIScreen.main.bounds.width * 0.7), height: UIScreen.main.bounds.height, alignment: .leading)
                        .shadow(radius: 5)
                        .transition(.move(edge: .leading))
                        Spacer()
                }
                .transition(.move(edge: .leading))
                .edgesIgnoringSafeArea(.all)
                    
            }
            
            
            
        }
        
    }
        
        
    
}
