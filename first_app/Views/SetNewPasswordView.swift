//
//  SetNewPasswordView.swift
//  PostApp
//
//  Created by Vladyslav Savkiv on 05/10/2025.
//

import SwiftUI

public struct SetNewPasswordView: View {
    
    @EnvironmentObject var appState: AppState

    private let userStore: UserStore = UserStore.shared

    
    @State var email: String
    @State var newPassword: String = ""
    @State var confirmNewPassword: String = ""
    @State var showPassword: Bool = false
    @State var showConfirmPassword: Bool = false
    @State var errorMessage: String?
    
    
    
    public var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 20) {
                
                Text("Set new password")
                    .font(.largeTitle)
                    .bold()
                
                HStack{
                    ZStack(alignment: .trailing) {
                        
                        
                        
                        Group {
                            if(!showPassword) { SecureField("Password", text: $newPassword)
                            } else { TextField("Password", text: $newPassword) }
                        }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    
                    
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image( systemName: showPassword ? "eye.slash.fill" : "eye")
                    }
                    .padding()
                    
                } //ZStack
                   
                                
                } //HStack
                
                HStack{
                    ZStack(alignment: .trailing) {
                        
                        Group {
                            if(!showConfirmPassword) { SecureField("Confirm Password", text: $confirmNewPassword)
                            } else { TextField("Confirm Password", text: $confirmNewPassword) }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    
                    Button {
                        showConfirmPassword.toggle()
                    } label: {
                        Image( systemName: showConfirmPassword ? "eye.slash.fill" : "eye")
                    }
                    .padding()
                    
                } //ZStack
                   
                                
                } //HStack
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button {
                    Task {
                        if (newPassword != confirmNewPassword) {
                            errorMessage = "Passwords do not match"
                            return
                        }
                        await userStore.updatePassword(email, newPassword)
                        
                    }
                } label: {
                    Text("Confirm")
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        appState.currentScreen = .login
                    } label: {
                        Text("Cancel")
                            .bold()
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
