//
//  PushNotifications.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 06/09/2025.
//

import UIKit
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
        
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //print("can request")
        
        let center = UNUserNotificationCenter.current()
        
        center.delegate = self
        
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        let token = "0987654321"
        AppState.shared.deviceToken = token
        
        
        
        
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("application")
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
        
        AppState.shared.deviceToken = token
    
    
        
    }
    
    
    
}
