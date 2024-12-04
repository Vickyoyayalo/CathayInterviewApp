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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupBindings()
        viewModel.fetchNotifications()
    }
    
    private func setupUI() {
        // 通知按鈕
        notificationButton.setImage(UIImage(systemName: "bell"), for: .normal)
        notificationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notificationButton)
        
        // 紅點
        redDotLabel.backgroundColor = .red
        redDotLabel.layer.cornerRadius = 5
        redDotLabel.clipsToBounds = true
        redDotLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(redDotLabel)
        
        // 設置約束
        NSLayoutConstraint.activate([
            notificationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            notificationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notificationButton.widthAnchor.constraint(equalToConstant: 30),
            notificationButton.heightAnchor.constraint(equalToConstant: 30),
            
            redDotLabel.widthAnchor.constraint(equalToConstant: 10),
            redDotLabel.heightAnchor.constraint(equalToConstant: 10),
            redDotLabel.centerXAnchor.constraint(equalTo: notificationButton.trailingAnchor),
            redDotLabel.centerYAnchor.constraint(equalTo: notificationButton.topAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.redDotLabel.isHidden = !self!.viewModel.hasNotifications
            }
        }
    }
}

