//
//  JSONHelper.swift
//  first_app
//
//  Created by Vladyslav Savkiv on 20/09/2025.
//

import Foundation

struct JSONHelper {
    
    
    static func makeDecoder() -> JSONDecoder {
        let decoder : JSONDecoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter())
        return decoder
    }
    
    static func makeEncoder() -> JSONEncoder {
        let encoder : JSONEncoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(formatter())
        return encoder
    }
    
    private static func formatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
}
