//
//  NotificationListViewModel.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/4.
//

import Foundation

class NotificationListViewModel {
    private var notifications: [Notification] = [] {
        didSet {
            self.updateUI?()
        }
    }
    
    var updateUI: (() -> Void)?
    
    var notificationCount: Int {
        return notifications.count
    }
    
    func notification(at index: Int) -> Notification {
        return notifications[index]
    }
    
    func fetchNotifications() {
        APIService.shared.fetchNotifications { [weak self] result in
            switch result {
            case .success(let notifications):
                self?.notifications = notifications
                print("ViewModel: Notifications fetched and updateUI triggered.")
                self?.updateUI?() // 確保此回調被觸發
            case .failure(let error):
                print("Error fetching notifications: \(error)")
            }
        }
    }
    
    func markAsRead(at index: Int) {
        notifications[index].status = true
        updateUI?()
    }
}

