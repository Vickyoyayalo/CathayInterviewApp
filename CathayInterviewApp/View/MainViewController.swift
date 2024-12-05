//
//  MainViewController.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/4.
//

import UIKit

class MainViewController: UIViewController {

    private let viewModel = MainViewModel()
    private let accountBalanceViewModel = AccountBalanceViewModel()
    private let redDotLabel = UILabel()
    private let accountBalanceView = AccountBalanceViewController()

    struct RedDotPosition {
        static let offsetX: CGFloat = -3
        static let offsetY: CGFloat = 3
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchNotifications()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.fromHex("#F5F5F5")

        // Notification Button
        let notificationButton = UIButton(type: .system)
        notificationButton.setImage(UIImage(systemName: "bell"), for: .normal)
        notificationButton.tintColor = .black
        notificationButton.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)

        let barButtonItem = UIBarButtonItem(customView: notificationButton)
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

        // Add AccountBalanceView
        accountBalanceView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(accountBalanceView)

        NSLayoutConstraint.activate([
            accountBalanceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            accountBalanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            accountBalanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupBindings() {
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                let hasNotifications = self?.viewModel.hasNotifications ?? false
                self?.redDotLabel.isHidden = !hasNotifications
                print("MainViewController updated redDotLabel: hasNotifications = \(hasNotifications)")
            }
        }

        accountBalanceView.onToggleVisibility = {
            print("Account balance visibility toggled")
        }
    }

    @objc private func notificationButtonTapped() {
        let notificationListVC = NotificationListViewController()
        navigationController?.pushViewController(notificationListVC, animated: true)
    }
}
