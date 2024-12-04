//
//  MainViewController.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/4.
//

import UIKit

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private let notificationButton = UIButton(type: .system)
    private let redDotLabel = UILabel()
    
    struct RedDotPosition {
        static let offsetX: CGFloat = -5
        static let offsetY: CGFloat = 5
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchNotifications()
    }
    
    private func setupUI() {
        view.backgroundColor = .white

        notificationButton.setImage(UIImage(systemName: "bell"), for: .normal)
        notificationButton.tintColor = .black
        notificationButton.translatesAutoresizingMaskIntoConstraints = false
        notificationButton.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside) // 添加點擊事件
        view.addSubview(notificationButton)

        redDotLabel.backgroundColor = UIColor.fromHex("#FF5733")
        redDotLabel.layer.cornerRadius = 5
        redDotLabel.layer.borderWidth = 1.5
        redDotLabel.layer.borderColor = UIColor.white.cgColor
        redDotLabel.clipsToBounds = true
        redDotLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(redDotLabel)

        NSLayoutConstraint.activate([
            notificationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            notificationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notificationButton.widthAnchor.constraint(equalToConstant: 30),
            notificationButton.heightAnchor.constraint(equalToConstant: 30),

            redDotLabel.widthAnchor.constraint(equalToConstant: 10),
            redDotLabel.heightAnchor.constraint(equalToConstant: 10),

            redDotLabel.topAnchor.constraint(equalTo: notificationButton.topAnchor, constant: RedDotPosition.offsetY),
            redDotLabel.trailingAnchor.constraint(equalTo: notificationButton.trailingAnchor, constant: RedDotPosition.offsetX)
        ])
    }

    @objc private func notificationButtonTapped() {
        let notificationListVC = NotificationListViewController()
        navigationController?.pushViewController(notificationListVC, animated: true) 
    }
    
    private func setupBindings() {
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.redDotLabel.isHidden = !self!.viewModel.hasNotifications
            }
        }
    }
}

