//
//  DeviceTokenSender.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 06/09/2025.
//

import Foundation
import Network

class DeviceTokenSender {
    

    func sendDeviceToken(deviceToken: String) async {
        
        guard let baseURL = Secrets.shared.baseUrlUni else { return }


        guard let url = URL(string: "\(baseURL)/devices/register") else { return}
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue( "application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: String] = ["deviceToken": deviceToken]
            if let token = AppState.shared.token {
                request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                print("Token is here:\(token)")
        }
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
            
            
            do{
                let (_, Response) = try await URLSession.shared.data(for: request)
                if let httpResponse = Response as? HTTPURLResponse {
                    print("statusCode arr: \(httpResponse.statusCode)")
                }
            } catch {
                print("error \(error)")
            }
            
        
    }
}
