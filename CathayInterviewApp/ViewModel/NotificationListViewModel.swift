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
    
    init() {
        NotificationManager.shared.addObserver { [weak self] in
            self?.notifications = NotificationManager.shared.getNotifications()
            self?.updateUI?()
            print("NotificationListViewModel notified to update UI")
        }
    }
    
    var notificationCount: Int {
        return notifications.count
    }
    
    func notification(at index: Int) -> Notification {
        return notifications[index]
    }
    
    func fetchNotifications() {
        NotificationManager.shared.fetchNotifications { [weak self] notifications in
            self?.notifications = notifications
            self?.updateUI?()
            print("NotificationListViewModel fetched notifications")
        }
    }
    
    func markAsRead(at index: Int) {
        let notification = notifications[index]
        NotificationManager.shared.markAsRead(notification: notification)
        print("NotificationListViewModel marked notification at index \(index) as read")
    }
    
    func areAllNotificationsRead() -> Bool {
        return !notifications.contains(where: { !$0.status })
    }
}
