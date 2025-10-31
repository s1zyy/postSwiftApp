//
//  ForgotPasswordView.swift
//  PostApp
//
//  Created by Vladyslav Savkiv on 01/10/2025.
//

import SwiftUI

public struct ForgotPasswordView: View {
    
    @EnvironmentObject var appState: AppState

    @State private var email: String = ""
    @State private var isLoading: Bool = false
    @State private var isSendingAgain: Bool = false
    @State private var message: String?
    @State private var codeSpace: Bool = false
    @State private var code: String = ""
    

    
    private let userStore: UserStore = UserStore.shared

    
    public var body: some View {
        
        
       
        NavigationStack {
            VStack {
                Text("Change Password")
                    .font(.largeTitle)
                    .bold()
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .disabled(codeSpace == true)
                
                
                if(codeSpace) {
                    
                
                TextField("Enter code from the Email", text: $code)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    
                    
                    Button {
                        Task {
                            isLoading = true
                            let isCodeCorrect = await userStore.sendPasswordCode(email, code)
                            isLoading = false
                            if(isCodeCorrect) {
                                appState.currentScreen = .resetPassword(email: email)
                            } else {
                                message = "Try to insert last code from your email!"
                            }
                        }
                        
                    } label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        } else {
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
                    .disabled(code.isEmpty)
                    .disabled(isLoading)
                    .padding()
                    .animation(.easeInOut, value: isLoading)
                    
                    Button {
                        Task{
                            isSendingAgain = true
                            var _ = await userStore.requestPasswordReset(email)
                            isSendingAgain = false
                        }
                    } label: {
                        if isSendingAgain {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        } else {
                            Text("Resend code")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                       
                        
                    }
                    
                    if let error = message {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                } else{
                    Button {
                        Task {
                            isLoading = true
                            let isEmailCorrect = await userStore.requestPasswordReset(email)
                            isLoading = false
                                        
                            if (isEmailCorrect){
                                codeSpace = true
                                
                            } else {
                                message = "Email not found"
                            }
                            
                            
                        }
                        
                    } label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        } else {
                            Text("Request Code" )
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
                    .disabled(email.isEmpty)
                    .disabled(isLoading)
                    .padding()
                    .animation(.easeInOut, value: isLoading)
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
