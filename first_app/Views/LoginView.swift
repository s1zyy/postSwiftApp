//
//  LoginView.swift
//  first_app

//  Created by Vladyslav Savkiv on 02/09/2025.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var appState: AppState
    
    @State var username: String = ""
    @State var password: String = ""
    @State var errorMessage: String? = nil
    @State var isLoading: Bool = false
    @State var token: String? = nil
    @State var showSignUp: Bool = false
    

    
    var body: some View {
        NavigationStack {
            
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .bold()
                        
            
            TextField("Username", text: $username)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.subheadline)
            }
            
            Button(action: {
                Task {
                    await loginButtonTapped()
                }
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.7))
                        )
                        .shadow(radius: 4)
                } else {
                    Text("Login")
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
            .buttonStyle(PlainButtonStyle())
            
            Button {
                appState.currentScreen = .forgotPassword
            } label: {
                Text("Forgot Password?")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 40)
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Sign Up") {
                    showSignUp.toggle()
                }
            }
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }

    }
    }
    
    func loginButtonTapped() async {
        isLoading = true
        errorMessage = nil
        
        
        do {
            try await login(username: username, password: password)
            
            if let deviceToken = appState.deviceToken {
                Task {
                    await DeviceTokenSender().sendDeviceToken(deviceToken: deviceToken)
                }
            }
            
        } catch {
            errorMessage = "Invalid credentials"
        }
        
        isLoading = false
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState.shared)
}

