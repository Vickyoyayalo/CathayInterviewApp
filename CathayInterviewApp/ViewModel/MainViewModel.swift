//
//  MainViewModel.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/4.
//

import Foundation

class MainViewModel {
    var updateUI: (() -> Void)?
    
    init() {
        NotificationManager.shared.addObserver { [weak self] in
            self?.updateUI?()
            print("MainViewModel notified to update UI")
        }
    }
    
    var hasNotifications: Bool {
        return NotificationManager.shared.hasUnreadNotifications()
    }
    
    func fetchNotifications() {
        NotificationManager.shared.fetchNotifications { [weak self] _ in
            self?.updateUI?()
            print("MainViewModel fetched notifications")
        }
    }
}
