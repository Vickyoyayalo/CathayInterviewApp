//
//  MainViewController.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/4.
//

import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
    private let refreshControl = UIRefreshControl()
    
    private let accountBalanceView = AccountBalanceView()
    private let accountBalanceViewModel = AccountBalanceViewModel()
    private let redDotLabel = UILabel()
    private let adBannerView = AdBannerView()
    
    // MARK: - ViewModels
    
    private let viewModel = MainViewModel()
    private let favoriteListViewModel = FavoriteListViewModel()
    private let adBannerViewModel = AdBannerViewModel()
    
    // MARK: - State Flags

    private var hasScrolled = false
    private var didPullRefresh = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupScrollView()
        setupSubviews()
        setupConstraints()
        setupBindings()
        
        viewModel.fetchNotifications()
        accountBalanceView.viewModel = accountBalanceViewModel
        accountBalanceViewModel.fetchBalances(apiType: "firstOpen")
        favoriteListViewModel.fetchFavoriteList(isEmpty: true)
        adBannerViewModel.loadBannersWithPlaceholder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchNotifications()
    }
    
    // MARK: - Setup Methods
    
    private func setupNavigationBar() {
        // Avatar
        let avatarContainer = UIView()
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        avatarContainer.widthAnchor.constraint(equalToConstant: 48).isActive = true
        avatarContainer.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let avatarImageView = UIImageView()
        avatarImageView.image = UIImage(named: "avatar")
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 16
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarContainer.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: avatarContainer.leadingAnchor, constant: 8),
            avatarImageView.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 42),
            avatarImageView.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        let avatarBarButtonItem = UIBarButtonItem(customView: avatarContainer)
        navigationItem.leftBarButtonItem = avatarBarButtonItem
        
        // Notification Button
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
            notificationButton.trailingAnchor.constraint(equalTo: notificationContainer.trailingAnchor, constant: -8),
            notificationButton.centerYAnchor.constraint(equalTo: notificationContainer.centerYAnchor),
            notificationButton.widthAnchor.constraint(equalToConstant: 25),
            notificationButton.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        let barButtonItem = UIBarButtonItem(customView: notificationContainer)
        navigationItem.rightBarButtonItem = barButtonItem
        
        // Red Dot
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
            redDotLabel.topAnchor.constraint(equalTo: notificationButton.topAnchor, constant: 3),
            redDotLabel.trailingAnchor.constraint(equalTo: notificationButton.trailingAnchor, constant: -3)
        ])
        
        redDotLabel.isHidden = true
        notificationButton.isEnabled = false
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        // Refresh Control
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func setupSubviews() {
        // Menu Icons View
        let menuIconsView = MenuIconsView.withDefaultIcons()
        
        // Favorite List View
        let favoriteListView = FavoriteListView()
        favoriteListView.favoriteListViewModel = favoriteListViewModel
        
        // Ad Banner View
        adBannerView.viewModel = adBannerViewModel
        adBannerView.isHidden = false
        
        // Account Balance
        accountBalanceView.viewModel = accountBalanceViewModel
        
        [accountBalanceView, menuIconsView, favoriteListView, adBannerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        
        accountBalanceView.onToggleVisibility = { }
        
        scrollView.panGestureRecognizer.require(toFail: adBannerView.collectionView.panGestureRecognizer)
    }
    
    private func setupConstraints() {
        let menuIconsView = scrollView.subviews.compactMap { $0 as? MenuIconsView }.first!
        let favoriteListView = scrollView.subviews.compactMap { $0 as? FavoriteListView }.first!
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            accountBalanceView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 24),
            accountBalanceView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -24),
            accountBalanceView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            accountBalanceView.heightAnchor.constraint(equalToConstant: 200),
            
            menuIconsView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            menuIconsView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            menuIconsView.topAnchor.constraint(equalTo: accountBalanceView.bottomAnchor, constant: 8),
            
            favoriteListView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 24),
            favoriteListView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -24),
            favoriteListView.topAnchor.constraint(equalTo: menuIconsView.bottomAnchor, constant: 16),
            favoriteListView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -48),
            favoriteListView.heightAnchor.constraint(equalToConstant: 140),
            
            adBannerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 24),
            adBannerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -24),
            adBannerView.topAnchor.constraint(equalTo: favoriteListView.bottomAnchor, constant: -12),
            adBannerView.heightAnchor.constraint(equalToConstant: 150),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: adBannerView.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let hasNotifications = self.viewModel.hasNotifications
                
                self.redDotLabel.isHidden = !self.didPullRefresh || !hasNotifications
            }
        }
        
        accountBalanceViewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func notificationButtonTapped() {
        let notificationListVC = NotificationListViewController()
        navigationController?.pushViewController(notificationListVC, animated: true)
    }
    
    @objc private func handleRefresh() {
        didPullRefresh = true
        if accountBalanceViewModel.isFirstOpen && accountBalanceViewModel.isBalanceHidden {
            accountBalanceViewModel.isFirstOpen = false
            accountBalanceViewModel.updateUI?()
        } else {
            
            accountBalanceViewModel.refreshBalances()
        }
        favoriteListViewModel.fetchFavoriteList(isEmpty: false)
        adBannerViewModel.loadBanners()
        adBannerView.startAutoScroll()
        viewModel.fetchNotifications()
        refreshControl.endRefreshing()
        if let notificationButton = self.navigationItem.rightBarButtonItem?.customView?.subviews.first(where: { $0 is UIButton }) as? UIButton {
            notificationButton.isEnabled = true
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !hasScrolled {
            hasScrolled = true
            favoriteListViewModel.fetchFavoriteList(isEmpty: true)
        }
    }
}
