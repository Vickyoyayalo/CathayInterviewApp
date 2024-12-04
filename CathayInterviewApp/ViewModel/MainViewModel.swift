//
//  MainViewModel.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/4.
//

import Foundation

class MainViewModel {
    private var notifications: [Notification] = [] {
        didSet {
            self.updateUI?()
        }
    }

    var updateUI: (() -> Void)?

    var notificationCount: Int {
        notifications.count
    }

    var hasNotifications: Bool {
        !notifications.isEmpty
    }

    func fetchNotifications() {
        APIService.shared.fetchNotifications { [weak self] result in
            switch result {
            case .success(let notifications):
                self?.notifications = notifications
            case .failure(let error):
                print("Error fetching notifications: \(error)")
                self?.notifications = []
            }
        }
    }
}
