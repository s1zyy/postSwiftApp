//
//  SignUpView.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 08/09/2025.
//



import SwiftUI

struct SignUpView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var errorMessage: String? = nil
    @State var showPassword: Bool = false
    @State var showConfirmPassword: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        NavigationStack{
            
            
            VStack(spacing: 20){
                
                
                
                
                
                Text("Sign Up")
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
                HStack{
                    ZStack(alignment: .trailing) {
                        
                        
                        
                        Group {
                            if(!showPassword) { SecureField("Password", text: $password)
                            } else { TextField("Password", text: $password) }
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
                            if(!showConfirmPassword) { SecureField("Password", text: $confirmPassword)
                            } else { TextField("Password", text: $confirmPassword) }
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
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Button {
                    Task {
                        if (password != confirmPassword) {
                            errorMessage = "Passwords do not match"
                            return
                        }
                        if let message = await signUp(email: email, password: password) {
                            if message == "User created successfully!" {
                                dismiss()
                            } else {
                                errorMessage = message
                            }
                        }
                        
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
                .buttonStyle(PlainButtonStyle())
                
                
                
            } //VStack
            .padding(.horizontal, 24)
            .padding(.vertical, 40)
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                    .font(.body).bold()
                }
            }
        }
        
    }
    func signUp(email: String, password: String) async -> String? {
        guard let baseURL = Secrets.shared.localhost else { return nil}
        
        guard let url = URL(string: "\(baseURL)/users") else { return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let user: User = .init(email: email, password: password)
        
        
        request.httpBody = try? JSONEncoder().encode(user)
        
        do {
            let ( data,_ ) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(ApiReturn.self, from: data)
            return decoded.message
        } catch {
            return "Please type correct Email"
        }
        
    }
}
