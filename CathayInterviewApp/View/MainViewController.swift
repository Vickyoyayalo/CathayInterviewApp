//
//  MainViewController.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/4.
//

import UIKit

class MainViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let accountBalanceView = AccountBalanceView()
    private let viewModel = MainViewModel()
    private let accountBalanceViewModel = AccountBalanceViewModel()
    private let redDotLabel = UILabel()
    private let refreshControl = UIRefreshControl()
    
    struct RedDotPosition {
        static let offsetX: CGFloat = -3
        static let offsetY: CGFloat = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        viewModel.fetchNotifications()
        
        accountBalanceView.viewModel = accountBalanceViewModel
        print("AccountBalanceView's viewModel is set: \(accountBalanceView.viewModel === accountBalanceViewModel)")
        
        accountBalanceViewModel.fetchBalances(apiType: "firstOpen")
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        accountBalanceView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(accountBalanceView)
        
        NSLayoutConstraint.activate([
            accountBalanceView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24),
            accountBalanceView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24),
            accountBalanceView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchNotifications()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
      
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.widthAnchor.constraint(equalToConstant: 48).isActive = true
        container.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let avatarImageView = UIImageView()
        avatarImageView.image = UIImage(named: "avatar")
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 16
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(avatarImageView)
       
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            avatarImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 42),
            avatarImageView.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        let avatarBarButtonItem = UIBarButtonItem(customView: container)
        self.navigationItem.leftBarButtonItem = avatarBarButtonItem
        
        let notificationContainer = UIView()
        notificationContainer.translatesAutoresizingMaskIntoConstraints = false
        notificationContainer.widthAnchor.constraint(equalToConstant: 48).isActive = true
        notificationContainer.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let notificationButton = UIButton(type: .system)
        notificationButton.setImage(UIImage(systemName: "bell"), for: .normal)
        notificationButton.tintColor = .black
        notificationButton.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        notificationButton.translatesAutoresizingMaskIntoConstraints = false
        
        notificationContainer.addSubview(notificationButton)
        
        NSLayoutConstraint.activate([
            notificationButton.trailingAnchor.constraint(equalTo: notificationContainer.trailingAnchor, constant: -24),
            notificationButton.centerYAnchor.constraint(equalTo: notificationContainer.centerYAnchor),
            notificationButton.widthAnchor.constraint(equalToConstant: 25),
            notificationButton.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        let barButtonItem = UIBarButtonItem(customView: notificationContainer)
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        redDotLabel.backgroundColor = UIColor.fromHex("#FF5733")
        redDotLabel.layer.cornerRadius = 5
        redDotLabel.layer.borderWidth = 1.5
        redDotLabel.layer.borderColor = UIColor.white.cgColor
        redDotLabel.clipsToBounds = true
        redDotLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationButton.addSubview(redDotLabel)
        
        NSLayoutConstraint.activate([
            redDotLabel.widthAnchor.constraint(equalToConstant: 10),
            redDotLabel.heightAnchor.constraint(equalToConstant: 10),
            redDotLabel.topAnchor.constraint(equalTo: notificationButton.topAnchor, constant: RedDotPosition.offsetY),
            redDotLabel.trailingAnchor.constraint(equalTo: notificationButton.trailingAnchor, constant: RedDotPosition.offsetX)
        ])
        accountBalanceView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(accountBalanceView)
        
        NSLayoutConstraint.activate([
            accountBalanceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            accountBalanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            accountBalanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func setupBindings() {
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                let hasNotifications = self?.viewModel.hasNotifications ?? false
                self?.redDotLabel.isHidden = !hasNotifications
            }
            
            self?.accountBalanceView.onRefreshComplete = { [weak self] in
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    @objc private func notificationButtonTapped() {
        let notificationListVC = NotificationListViewController()
        navigationController?.pushViewController(notificationListVC, animated: true)
    }
    
    @objc private func handleRefresh() {
        accountBalanceViewModel.fetchBalances(apiType: "pullRefresh")
    }
}
