//
//  AccountBalanceViewModel.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/5.
//

class AccountBalanceViewModel {
    private(set) var usdBalance: String = "********"
    private(set) var khrBalance: String = "********"
    var isBalanceHidden: Bool = true {
        didSet {
            updateBalances()
            updateUI?()
        }
    }

    var updateUI: (() -> Void)?

    func toggleBalanceVisibility() {
        isBalanceHidden.toggle()
    }

    private func updateBalances() {
        if isBalanceHidden {
            usdBalance = "********"
            khrBalance = "********"
        } else {
            // 模擬實際數據
            usdBalance = "1,000.00"
            khrBalance = "4,000,000.00"
        }
    }
}
