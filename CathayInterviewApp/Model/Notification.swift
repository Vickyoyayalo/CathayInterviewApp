//
//  Notification.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/4.
//

import Foundation

struct NotificationResponse: Decodable {
    let msgCode: String
    let msgContent: String
    let result: NotificationResult
}

struct NotificationResult: Decodable {
    let messages: [Notification]
}

struct Notification: Equatable, Decodable, Identifiable {
    let id: String
    let title: String
    let message: String
    var status: Bool
    let updateDateTime: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case message
        case status
        case updateDateTime
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.message = try container.decode(String.self, forKey: .message)
        self.status = try container.decode(Bool.self, forKey: .status)
        let rawDateTime = try container.decode(String.self, forKey: .updateDateTime)
        self.updateDateTime = Notification.standardizeDateTime(rawDateTime)
        self.id = Notification.generateID(title: self.title, message: self.message, updateDateTime: self.updateDateTime)
    }
    
    // use title、message and updateDateTime to create an hash value into id
    static func generateID(title: String, message: String, updateDateTime: String) -> String {
        let combinedString = title + message + updateDateTime
        return String(combinedString.hashValue)
    }
    
    static func standardizeDateTime(_ rawDateTime: String) -> String {
        let dateFormats = ["yyyy/MM/dd HH:mm:ss", "HH:mm:ss yyyy/MM/dd", "yyyy/MM/dd HH:mm", "HH:mm yyyy/MM/dd"]
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        for format in dateFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: rawDateTime) {
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                return formatter.string(from: date)
            }
        }
        return rawDateTime
    }
}







