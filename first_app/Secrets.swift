//
//  Secrets.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 07/09/2025.
//

import Foundation

class Secrets {
    static let shared = Secrets()
    
    private var dict: [String: Any] = [:]
    
    private init() {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let loadedDict = NSDictionary(contentsOfFile: path) as? [String: Any] {
            dict = loadedDict
        }
    }
    
    
    func value(forKey key: String) -> String? {
        return dict[key] as? String
    }
    
    var baseUrlHome: String? { value(forKey: "API_URL_HOME") }
    var baseUrlUni: String? { value(forKey: "API_URL_EDU") }
    var baseUrlNick: String? { value(forKey: "API_URL_NICK") }
    var localhost: String? { value(forKey: "API_URL_LOCALHOST") }
    
    

}
