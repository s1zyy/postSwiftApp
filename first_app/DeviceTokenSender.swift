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
        guard let baseURL = Secrets.shared.localhost else { return }
        
        let endpoint = "\(baseURL)/devices/register"
        let body: [String: String] = ["deviceToken": deviceToken]
            
            do{
                let request = try NetworkHelper.makeRequest(endpoint: endpoint, token: AppState.shared.token, method: "POST", body: body)

                let (_, Response) = try await URLSession.shared.data(for: request)
                if let httpResponse = Response as? HTTPURLResponse {
                    print("statusCode arr: \(httpResponse.statusCode)")
                }
            } catch {
                print("error \(error)")
            }        
    }
}
