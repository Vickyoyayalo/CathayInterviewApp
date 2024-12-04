//
//  NotificationListViewController.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/4.
//

import UIKit

class NotificationListViewController: UIViewController {
    
    // ViewModel
    private let viewModel = NotificationListViewModel()
    
    // TableView
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchNotifications() // 加載通知列表
        print("TableView is added to view: \(tableView.superview != nil)")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Notifications"
        
        // 添加 TableView
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        print("Data source and delegate set")
    }
    
    private func setupBindings() {
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                print("Reloading TableView") // 確認這裡被調用
                self?.tableView.reloadData()
            }
        }
    }
}

extension NotificationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(viewModel.notificationCount)") // 打印行數，檢查是否為 0
        return viewModel.notificationCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as? NotificationCell else {
            return UITableViewCell()
        }
        let notification = viewModel.notification(at: indexPath.row)
        print("Notification: \(notification)")
        cell.configure(with: notification)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.markAsRead(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
