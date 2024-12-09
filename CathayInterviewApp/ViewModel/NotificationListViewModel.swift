//
//  NotificationListViewModel.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/4.
//

import Foundation

class NotificationListViewModel {
    
    private var notifications: [Notification] = []
    var updateUI: (() -> Void)?
    
    // MARK: - Initializers
    
    init() {
        NotificationManager.shared.addObserver { [weak self] in
            self?.notifications = NotificationManager.shared.getNotifications()
            self?.updateUI?()
            print("NotificationListViewModel notified to update UI")
        }
    }
    
    // MARK: - Computed Properties
    
    var notificationCount: Int {
        return notifications.count
    }
    
    // MARK: - Notification Management
    
    func notification(at index: Int) -> Notification {
        return notifications[index]
    }
    
    // MARK: - Fetch Notifications
    
    func fetchNotifications() {
        NotificationManager.shared.fetchNotifications { [weak self] notifications in
            self?.notifications = notifications
            self?.updateUI?()
            print("NotificationListViewModel fetched notifications")
        }
    }
    
    // MARK: - Mark Notification as Read
    
    func markAsRead(at index: Int) {
        let notification = notifications[index]
        NotificationManager.shared.markAsRead(notification: notification)
        print("NotificationListViewModel marked notification at index \(index) as read")
    }
    
    // MARK: - Check All Notifications Read Status
    
    func areAllNotificationsRead() -> Bool {
        return !notifications.contains(where: { !$0.status })
    }
}
