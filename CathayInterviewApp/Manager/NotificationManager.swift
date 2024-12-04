//
//  NotificationManager.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/4.
//
import Foundation

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {
        readNotificationIDs = Set(UserDefaults.standard.array(forKey: "ReadNotificationIDs") as? [String] ?? [])
    }
    
    private var notifications: [Notification] = [] {
        didSet {
            notifyObservers()
        }
    }
    
    private var readNotificationIDs: Set<String> = []
    
    private var observers: [() -> Void] = []
    
    func addObserver(_ observer: @escaping () -> Void) {
        observers.append(observer)
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer()
        }
    }
    
    func fetchNotifications(completion: @escaping ([Notification]) -> Void) {
        APIService.shared.fetchNotifications { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fetchedNotifications):
               
                self.notifications = fetchedNotifications.map { notification in
                    var updatedNotification = notification
                    if self.readNotificationIDs.contains(notification.id) {
                        updatedNotification.status = true
                    }
                    return updatedNotification
                }
                completion(self.notifications)
            case .failure(let error):
                print("Error fetching notifications: \(error)")
                completion([])
            }
        }
    }
    
    func getNotifications() -> [Notification] {
        return notifications
    }
    
    func markAsRead(notification: Notification) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            
            notifications[index].status = true
            
            readNotificationIDs.insert(notification.id)
            
            UserDefaults.standard.set(Array(readNotificationIDs), forKey: "ReadNotificationIDs")
            
            notifyObservers()
            
            print("Marked notification \(notifications[index].id) as read")
        } else {
            print("Notification with id \(notification.id) not found.")
        }
    }
    
    func hasUnreadNotifications() -> Bool {
        return notifications.contains { !$0.status }
    }
}
