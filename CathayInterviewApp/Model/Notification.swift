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

struct Notification: Decodable {
    let status: Bool
    let updateDateTime: String
    let title: String
    let message: String
}


