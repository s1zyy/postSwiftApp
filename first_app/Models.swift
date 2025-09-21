//
//  Models.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 28/08/2025.
//

import SwiftUI

class Post: Identifiable, Codable, ObservableObject{
    var id: Int64?
    var title: String
    var content: String
    var createdAt: String?
    var updatedAt: String?
    var user: User?
    var reminder: Reminder?
    
    
    init(id: Int64? = nil, title: String, content: String, createdAt: String? = nil, updatedAt: String? = nil, reminder: Reminder? = nil, user: User? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.reminder = reminder
        self.user = user
    }
}

class User: Codable {
    var email: String
    var password: String
    var id: Int64?
    var username: String?
    var birthDate: Date?
    
    init(email: String, password: String, id: Int64? = nil, username: String? = nil, birthDate: Date? = nil ) {
        self.email = email
        self.password = password
        self.id = id
        self.username = username
        self.birthDate = birthDate
    }
}

class Reminder: Codable, ObservableObject {
    var id: Int64?
    var reminderTime: Date
    var completed: Bool
    
    init(id: Int64? = nil, reminderTime: Date, completed: Bool = false) {
        self.id = id
        self.reminderTime = reminderTime
        self.completed = completed
    }
    
    
    
    
}

struct ApiReturn: Codable {
    var message: String
}






