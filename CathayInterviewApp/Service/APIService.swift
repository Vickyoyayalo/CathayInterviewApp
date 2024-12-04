//
//  APIService.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/4.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    func fetchNotifications(completion: @escaping (Result<[Notification], Error>) -> Void) {
        let urlString = "https://willywu0201.github.io/data/notificationList.json"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let notificationResponse = try decoder.decode(NotificationResponse.self, from: data)
                let notifications = notificationResponse.result.messages
                completion(.success(notifications))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
