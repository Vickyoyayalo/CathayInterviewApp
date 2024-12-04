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
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }

            do {
                let response = try JSONDecoder().decode(NotificationResponse.self, from: data)
                completion(.success(response.result.messages))
            } catch {
                print("Decoding Error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}

