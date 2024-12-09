//
//  AccountBalanceViewModel.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/5.
//

import Foundation

class AccountBalanceViewModel {
    private(set) var usdBalance: String = "********"
    private(set) var khrBalance: String = "********"
    
    var isBalanceHidden: Bool = true {
        didSet {
            updateBalancesDisplay()
        }
    }
    
    var isFirstOpen: Bool = true
    
    var updateUI: (() -> Void)?
    
    private var usdTotalAmount: Double = 0.0
    private var khrTotalAmount: Double = 0.0
    
    func toggleBalanceVisibility() {
        isBalanceHidden.toggle()
        if !isBalanceHidden {
            isFirstOpen = false
        }
    }
    
    func fetchBalances(apiType: String) {
        let apiToFetch = isFirstOpen ? "firstOpen" : apiType
        let usdSavingsURL = apiToFetch == "firstOpen" ?
            "https://willywu0201.github.io/data/usdSavings1.json" :
            "https://willywu0201.github.io/data/usdSavings2.json"
        
        let usdFixedURL = apiToFetch == "firstOpen" ?
            "https://willywu0201.github.io/data/usdFixed1.json" :
            "https://willywu0201.github.io/data/usdFixed2.json"
        
        let usdDigitalURL = apiToFetch == "firstOpen" ?
            "https://willywu0201.github.io/data/usdDigital1.json" :
            "https://willywu0201.github.io/data/usdDigital2.json"
        
        let khrSavingsURL = apiToFetch == "firstOpen" ?
            "https://willywu0201.github.io/data/khrSavings1.json" :
            "https://willywu0201.github.io/data/khrSavings2.json"
        
        let khrFixedURL = apiToFetch == "firstOpen" ?
            "https://willywu0201.github.io/data/khrFixed1.json" :
            "https://willywu0201.github.io/data/khrFixed2.json"
        
        let khrDigitalURL = apiToFetch == "firstOpen" ?
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
        
        group.notify(queue: .main) {
            self.usdTotalAmount = usdSavingAmount + usdFixedAmount + usdDigitalAmount
            self.khrTotalAmount = khrSavingAmount + khrFixedAmount + khrDigitalAmount
            
            print("After fetch (apiType=\(apiToFetch)): USD total = \(self.usdTotalAmount), KHR total = \(self.khrTotalAmount)")
           
            if apiToFetch == "pullRefresh" {
                self.isFirstOpen = false
            }
            self.updateBalancesDisplay()
        }
    }
    
    private func updateBalancesDisplay() {
        if isBalanceHidden {
          
            if isFirstOpen {
                usdBalance = " "
                khrBalance = " "
            } else {
                usdBalance = "********"
                khrBalance = "********"
            }
        } else {
            usdBalance = String(format: "%.2f", usdTotalAmount)
            khrBalance = String(format: "%.2f", khrTotalAmount)
        }
        
        updateUI?()
    }
    
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
