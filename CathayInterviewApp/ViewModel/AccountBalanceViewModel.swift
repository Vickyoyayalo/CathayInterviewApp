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
            updateUI?()
        }
    }
    
    var updateUI: (() -> Void)?
    
    // 真實的金額數字（顯示前會先判斷 isBalanceHidden ）
    private var usdTotalAmount: Double = 0.0
    private var khrTotalAmount: Double = 0.0
    
    func toggleBalanceVisibility() {
        isBalanceHidden.toggle()
    }
    
    func fetchBalances(apiType: String) {
        let usdSavingsURL = apiType == "firstOpen" ?
            "https://willywu0201.github.io/data/usdSavings1.json" :
            "https://willywu0201.github.io/data/usdSavings2.json"
        
        let usdFixedURL = apiType == "firstOpen" ?
            "https://willywu0201.github.io/data/usdFixed1.json" :
            "https://willywu0201.github.io/data/usdFixed2.json"
        
        let usdDigitalURL = apiType == "firstOpen" ?
            "https://willywu0201.github.io/data/usdDigital1.json" :
            "https://willywu0201.github.io/data/usdDigital2.json"
        
        let khrSavingsURL = apiType == "firstOpen" ?
            "https://willywu0201.github.io/data/khrSavings1.json" :
            "https://willywu0201.github.io/data/khrSavings2.json"
        
        let khrFixedURL = apiType == "firstOpen" ?
            "https://willywu0201.github.io/data/khrFixed1.json" :
            "https://willywu0201.github.io/data/khrFixed2.json"
        
        let khrDigitalURL = apiType == "firstOpen" ?
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
        // KHR savings
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
            
            print("After fetch (apiType=\(apiType)): USD total = \(self.usdTotalAmount), KHR total = \(self.khrTotalAmount)")
            
            self.updateBalancesDisplay()
            self.updateUI?()
        }
    }
    
    private func updateBalancesDisplay() {
        if isBalanceHidden {
            usdBalance = "********"
            khrBalance = "********"
        } else {
            usdBalance = String(format: "%.2f", usdTotalAmount)
            khrBalance = String(format: "%.2f", khrTotalAmount)
        }
    }
    
    /// 傳入 URL 與對應的清單 Key ("savingsList", "fixedDepositList", "digitalList")
    /// 回傳該清單中全部帳戶 balance 的加總。
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
                // 解析 JSON
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = json["result"] as? [String: Any],
                   let accountList = result[listKey] as? [[String: Any]] {
                    
                    // 將所有的 "balance" 加總
                    let total = accountList.reduce(0.0) { partialResult, accountDict in
                        let balance = accountDict["balance"] as? Double ?? 0.0
                        return partialResult + balance
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
