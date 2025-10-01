//
//  ProfileView.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 21/09/2025.
//


import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var username: String = "User"
    @State private var birthDate: Date? = nil
    @State private var changeUsername: Bool = false
    @State private var changeBirthDate: Bool = false
    
    private let userStore: UserStore = UserStore.shared
    
    

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 200) {
                Text("Profile")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)
                
                
                //name
                HStack{
                    Text("Your name: ")
                        .font(.headline)
                    if(!changeUsername) {
                        Text(username)
                            .font(.title3)
                            .foregroundColor(.primary)
                            .padding(6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    } else {
                        TextField("Name", text: $username)
                            .textFieldStyle(.roundedBorder)
                            .font(.title3)
                    }
                    Spacer()
                    Button {
                        if(changeUsername) {
                            Task { await userStore.changeName(username)}
                        }
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            changeUsername.toggle()
                        }
                        
                        
                        
                    } label: {
                        
                        Image(systemName: changeUsername ? "checkmark.circle.fill" : "pencil.circle.fill")
                            .font(.title2)
                            .foregroundColor(changeUsername ? .green : .blue)
                            .scaleEffect(changeUsername ? 1.2 : 1.0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: changeUsername)
                    }
                    
                    
                }
                .padding(.horizontal)
                
                
                // birth date
                HStack{
                    Text("Date of birth: ")
                        .font(.body)
                        .padding(8)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(8)
                    if(!changeBirthDate){
                        
                        
                        
                        if let birthDate = birthDate {
                            
                            Text((DateFormatter.localizedString(from: birthDate, dateStyle: .medium, timeStyle: .none)))
                                .font(.body)
                                .padding(8)
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(8)
                                    
                            
                        
                        } else {
                            Text ("No date of birth")
                                .font(.body)
                                .italic()
                                .foregroundColor(.gray)
                                .padding(8)
                                .cornerRadius(8)
                            
                        }
                    } else {
                        
                        DatePicker("", selection: Binding(
                            get: { birthDate ?? Date() },
                            set: { newDate in
                                birthDate = newDate
                            }
                        ), displayedComponents: .date)
                        .labelsHidden()
                        .font(.body)
                        .padding(8)
                        .cornerRadius(8)
                        .background(.green)
                    }
                    
                    Button {
                        if(changeBirthDate) {
                            Task { await userStore.changeBirthDate(birthDate!)}
                        }
                        changeBirthDate.toggle()
                    } label: {
                        Image(systemName: changeBirthDate ? "checkmark.circle.fill" : "pencil.circle.fill")
                            .font(.title2)
                            .foregroundColor(changeBirthDate ? .green : .blue)
                            .scaleEffect(changeBirthDate ? 1.2 : 1.0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: changeBirthDate)
                        
                    }
                    
                }
                Spacer()
                
                
                
                
                
                
            }
            .padding()
            .onAppear {
                username = appState.currentUser?.username ?? ""
                birthDate = appState.currentUser?.birthDate
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        appState.currentScreen = .content
                    } label: {
                        Text("Back")
                            .bold()
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
