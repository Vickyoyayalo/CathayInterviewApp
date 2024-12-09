//
//  AccountBalanceViewModel.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/5.
//

import Foundation

// MARK: - ViewModel for Account Balance

class AccountBalanceViewModel {

    private(set) var usdBalance: String = "********"
    private(set) var khrBalance: String = "********"
    
    var isBalanceHidden: Bool = true {
        didSet {
            updateBalancesDisplay()
        }
    }
    
    var isFirstOpen: Bool = true
    var isLoading: Bool = false
    var updateUI: (() -> Void)?
    
    private var usdTotalAmount: Double = 0.0
    private var khrTotalAmount: Double = 0.0
    
    // MARK: - Toggle Visibility
    
    func toggleBalanceVisibility() {
        isBalanceHidden.toggle()
        if !isBalanceHidden {
            isFirstOpen = false
        }
        updateBalancesDisplay()
    }
    
    // MARK: - Fetch Balances from API
    
    func fetchBalances(apiType: String) {
        let finalApiType = isFirstOpen ? "firstOpen" : apiType
        
        isLoading = true
        updateUI?()
        
        APIService.shared.fetchBalances(apiType: finalApiType) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let (usdTotal, khrTotal)):
                    self.usdTotalAmount = usdTotal
                    self.khrTotalAmount = khrTotal
                    if finalApiType == "pullRefresh" {
//                        self.isFirstOpen = true
                    }
                case .failure(let error):
                    print("Fetch balances error: \(error)")
                }
                self.isLoading = false
                self.updateBalancesDisplay()
            }
        }
    }
    
    // MARK: - Refresh Balances
    
    func refreshBalances() {
        fetchBalances(apiType: "pullRefresh")
    }
    
    // MARK: - Update Balances Display
    
    private func updateBalancesDisplay() {
        if isBalanceHidden {
            usdBalance = " "
            khrBalance = " "
        } else {
            usdBalance = String(format: "%.2f", usdTotalAmount)
            khrBalance = String(format: "%.2f", khrTotalAmount)
        }
        updateUI?()
    }
}
