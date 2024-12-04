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
        static let offsetX: CGFloat = -3
        static let offsetY: CGFloat = 3
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchNotifications()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.fromHex("#F5F5F5")
        
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

