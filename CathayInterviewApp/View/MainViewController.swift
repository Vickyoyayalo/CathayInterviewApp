//
//  MainViewController.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/4.
//

import UIKit

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private let accountBalanceViewModel = AccountBalanceViewModel() // 新增 AccountBalance ViewModel
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        let balanceView = setupAccountBalanceView()
        balanceView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(balanceView)
        
        NSLayoutConstraint.activate([
            balanceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            balanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            balanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
        
        accountBalanceViewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                guard let balanceView = self?.view.viewWithTag(100) as? UIView,
                      let usdLabel = balanceView.viewWithTag(101) as? UILabel,
                      let khrLabel = balanceView.viewWithTag(102) as? UILabel else { return }
                
                usdLabel.text = "\(self?.accountBalanceViewModel.usdBalance ?? "********")"
                khrLabel.text = "\(self?.accountBalanceViewModel.khrBalance ?? "********")"
            }
        }
    }
    
    private func setupAccountBalanceView() -> UIView {
        let balanceView = UIView()
        balanceView.tag = 100

        let titleLabel = UILabel()
        titleLabel.text = "My Account Balance"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .gray

        let eyeButton = UIButton(type: .system)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal) // 初始隱藏
        eyeButton.tintColor = UIColor.fromHex("#FF5733")
        eyeButton.addTarget(self, action: #selector(toggleBalanceVisibility), for: .touchUpInside)

        let titleStack = UIStackView(arrangedSubviews: [titleLabel, eyeButton])
        titleStack.axis = .horizontal
        titleStack.spacing = 8
        titleStack.alignment = .center
        titleStack.distribution = .equalSpacing
        
        NSLayoutConstraint.activate([
            eyeButton.widthAnchor.constraint(equalToConstant: 24),
            eyeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
       
        let usdTitleLabel = UILabel()
        usdTitleLabel.text = "USD"
        usdTitleLabel.font = .systemFont(ofSize: 16)
        usdTitleLabel.textColor = .darkGray

        let usdValueLabel = UILabel()
        usdValueLabel.text = "********"
        usdValueLabel.font = .boldSystemFont(ofSize: 22)
        usdValueLabel.textColor = .darkGray
        usdValueLabel.tag = 101

        let khrTitleLabel = UILabel()
        khrTitleLabel.text = "KHR"
        khrTitleLabel.font = .systemFont(ofSize: 16)
        khrTitleLabel.textColor = .darkGray

        let khrValueLabel = UILabel()
        khrValueLabel.text = "********"
        khrValueLabel.font = .boldSystemFont(ofSize: 22)
        khrValueLabel.textColor = .darkGray
        khrValueLabel.tag = 102

        let usdStack = UIStackView(arrangedSubviews: [usdTitleLabel, usdValueLabel])
        usdStack.axis = .vertical
        usdStack.spacing = 4

        let khrStack = UIStackView(arrangedSubviews: [khrTitleLabel, khrValueLabel])
        khrStack.axis = .vertical
        khrStack.spacing = 4

        let balanceStack = UIStackView(arrangedSubviews: [usdStack, khrStack])
        balanceStack.axis = .vertical
        balanceStack.spacing = 16

        let stackView = UIStackView(arrangedSubviews: [titleStack, balanceStack])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        balanceView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: balanceView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: balanceView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: balanceView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: balanceView.trailingAnchor, constant: -130)
        ])

        return balanceView
    }


    @objc private func toggleBalanceVisibility() {
        accountBalanceViewModel.toggleBalanceVisibility()

        guard let balanceView = self.view.viewWithTag(100),
              let usdLabel = balanceView.viewWithTag(101) as? UILabel,
              let khrLabel = balanceView.viewWithTag(102) as? UILabel,
              let eyeButton = (balanceView.subviews.first as? UIStackView)?.arrangedSubviews[0].subviews[1] as? UIButton else { return }

        let isHidden = accountBalanceViewModel.isBalanceHidden
        eyeButton.setImage(UIImage(systemName: isHidden ? "eye.slash" : "eye"), for: .normal)

        usdLabel.text = isHidden ? "********" : "\(accountBalanceViewModel.usdBalance)"
        khrLabel.text = isHidden ? "********" : "\(accountBalanceViewModel.khrBalance)"
    }

    @objc private func notificationButtonTapped() {
        let notificationListVC = NotificationListViewController()
        navigationController?.pushViewController(notificationListVC, animated: true)
    }
}
