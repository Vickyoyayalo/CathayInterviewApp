//
//  APIService.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/4.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    // MARK: - Notifications
    
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
    
    // MARK: - Balances
    
    func fetchBalances(apiType: String, completion: @escaping (Result<(usdTotal: Double, khrTotal: Double), Error>) -> Void) {
       
        let finalApiType = apiType == "firstOpen" ? "firstOpen" : apiType
        let usdSavingsURL = finalApiType == "firstOpen" ?
        "https://willywu0201.github.io/data/usdSavings1.json" :
        "https://willywu0201.github.io/data/usdSavings2.json"
        
        let usdFixedURL = finalApiType == "firstOpen" ?
        "https://willywu0201.github.io/data/usdFixed1.json" :
        "https://willywu0201.github.io/data/usdFixed2.json"
        
        let usdDigitalURL = finalApiType == "firstOpen" ?
        "https://willywu0201.github.io/data/usdDigital1.json" :
        "https://willywu0201.github.io/data/usdDigital2.json"
        
        let khrSavingsURL = finalApiType == "firstOpen" ?
        "https://willywu0201.github.io/data/khrSavings1.json" :
        "https://willywu0201.github.io/data/khrSavings2.json"
        
        let khrFixedURL = finalApiType == "firstOpen" ?
        "https://willywu0201.github.io/data/khrFixed1.json" :
        "https://willywu0201.github.io/data/khrFixed2.json"
        
        let khrDigitalURL = finalApiType == "firstOpen" ?
        "https://willywu0201.github.io/data/khrDigital1.json" :
        "https://willywu0201.github.io/data/khrDigital2.json"
        
        let group = DispatchGroup()
        
        var usdSavingAmount: Double = 0
        var usdFixedAmount: Double = 0
        var usdDigitalAmount: Double = 0
        
        var khrSavingAmount: Double = 0
        var khrFixedAmount: Double = 0
        var khrDigitalAmount: Double = 0
        
        group.enter()
        fetchAmount(from: usdSavingsURL, listKey: "savingsList") { result in
            if case .success(let amount) = result {
                usdSavingAmount = amount
            }
            group.leave()
        }
        
        group.enter()
        fetchAmount(from: usdFixedURL, listKey: "fixedDepositList") { result in
            if case .success(let amount) = result {
                usdFixedAmount = amount
            }
            group.leave()
        }
        
        group.enter()
        fetchAmount(from: usdDigitalURL, listKey: "digitalList") { result in
            if case .success(let amount) = result {
                usdDigitalAmount = amount
            }
            group.leave()
        }
        
        group.enter()
        fetchAmount(from: khrSavingsURL, listKey: "savingsList") { result in
            if case .success(let amount) = result {
                khrSavingAmount = amount
            }
            group.leave()
        }
        
        group.enter()
        fetchAmount(from: khrFixedURL, listKey: "fixedDepositList") { result in
            if case .success(let amount) = result {
                khrFixedAmount = amount
            }
            group.leave()
        }
        
        group.enter()
        fetchAmount(from: khrDigitalURL, listKey: "digitalList") { result in
            if case .success(let amount) = result {
                khrDigitalAmount = amount
            }
            group.leave()
        }
        
        group.notify(queue: .global()) {
            let usdTotal = usdSavingAmount + usdFixedAmount + usdDigitalAmount
            let khrTotal = khrSavingAmount + khrFixedAmount + khrDigitalAmount
            completion(.success((usdTotal, khrTotal)))
        }
    }
    
    // MARK: - Favorite List
    
    func fetchFavoriteList(isEmpty: Bool, completion: @escaping (Result<[FavoriteItem], Error>) -> Void) {
        let urlString = isEmpty
        ? "https://willywu0201.github.io/data/emptyFavoriteList.json"
        : "https://willywu0201.github.io/data/favoriteList.json"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(FavoriteResponse.self, from: data)
                let list = response.result?.favoriteList ?? []
                completion(.success(list))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Private Helper
    
    private func fetchAmount(from urlString: String, listKey: String, completion: @escaping (Result<Double, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = json["result"] as? [String: Any],
                   let accountList = result[listKey] as? [[String: Any]] {
                    let total = accountList.reduce(0.0) { partial, dict in
                        partial + (dict["balance"] as? Double ?? 0.0)
                    }
                    completion(.success(total))
                } else {
                    completion(.failure(NSError(domain: "Data Parsing Error", code: -1)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
