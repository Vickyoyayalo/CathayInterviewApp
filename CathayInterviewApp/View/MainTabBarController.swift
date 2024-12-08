//
//  MainTabBarController.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/8.
//

import UIKit

class MainTabBarController: UITabBarController {

    private var tabBarBackgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBarAppearance()
        setupTabBarBackground()
    }

    private func setupTabs() {
        // Tab 1: Home
        let mainVC = MainViewController()
        let mainNavController = UINavigationController(rootViewController: mainVC)
        mainNavController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "TabbarHomeActive"),
            selectedImage: UIImage(named: "TabbarHomeActive")
        )

        // Tab 2: Account
        let accountVC = UIViewController()
        let accountNavController = UINavigationController(rootViewController: accountVC)
        accountNavController.tabBarItem = UITabBarItem(
            title: "Account",
            image: UIImage(named: "TabbarAccount"),
            selectedImage: UIImage(named: "TabbarAccount")
        )

        // Tab 3: Location
        let locationVC = UIViewController()
        let locationNavController = UINavigationController(rootViewController: locationVC)
        locationNavController.tabBarItem = UITabBarItem(
            title: "Location",
            image: UIImage(named: "TabbarLocation"),
            selectedImage: UIImage(named: "TabbarLocation")
        )

        // Tab 4: Service
        let serviceVC = UIViewController()
        let serviceNavController = UINavigationController(rootViewController: serviceVC)
        serviceNavController.tabBarItem = UITabBarItem(
            title: "Service",
            image: UIImage(systemName: "person.2.fill"),
            selectedImage: UIImage(systemName: "person.2.fill")
        )

        // Add tabs
        self.viewControllers = [mainNavController, accountNavController, locationNavController, serviceNavController]
    }

    private func setupTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .clear
        
        tabBarAppearance.shadowImage = nil
        tabBarAppearance.shadowColor = .clear
        
        // 設定文字位置偏移
        for item in tabBar.items ?? [] {
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2) // 調整文字的位置
            item.imageInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5) // 調整圖標的位置
        }
        

        tabBar.tintColor = UIColor.orange01
        tabBar.unselectedItemTintColor = UIColor.gray

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: Font.FavoriteName ?? UIFont.systemFont(ofSize: 12)
        ]
        UITabBarItem.appearance().setTitleTextAttributes(textAttributes, for: .normal)

        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }

    private func setupTabBarBackground() {
        tabBarBackgroundView = UIView()
        tabBarBackgroundView.backgroundColor = .white
        tabBarBackgroundView.layer.cornerRadius = 30
        tabBarBackgroundView.layer.shadowColor = UIColor.black.cgColor
        tabBarBackgroundView.layer.shadowOpacity = 0.1
        tabBarBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        tabBarBackgroundView.layer.shadowRadius = 6
        tabBarBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tabBarBackgroundView)
        view.bringSubviewToFront(tabBar)

        NSLayoutConstraint.activate([
            tabBarBackgroundView.heightAnchor.constraint(equalToConstant: 70),
            tabBarBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            tabBarBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabBarBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let height: CGFloat = 70
        let width: CGFloat = view.frame.width - 40
        var tabFrame = tabBar.frame
        tabFrame.size.height = height
        tabFrame.size.width = width
        tabFrame.origin.y = view.frame.height - height - 20
        tabFrame.origin.x = (view.frame.width - width) / 2
        tabBar.frame = tabFrame

        // Update tabBarBackgroundView's frame
        tabBarBackgroundView.frame = tabBar.frame
    }
}


//import UIKit
//
//class MainTabBarController: UITabBarController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTabs()
//        setupTabBarAppearance()
//        
//        for item in tabBar.items ?? [] {
//            item.imageInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5) // 調整圖標偏移
//            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)   // 調整文字偏移
//        }
//
//    }
//
//    private func setupTabs() {
//        // Tab 1: Home
//        let mainVC = MainViewController()
//        let mainNavController = UINavigationController(rootViewController: mainVC)
//        mainNavController.tabBarItem = UITabBarItem(
//            title: "Home",
//            image: UIImage(named: "TabbarHomeActive"),
//            selectedImage: UIImage(named: "TabbarHomeActive")
//        )
//
//        // Tab 2: Account
//        let accountVC = UIViewController()
//        let accountNavController = UINavigationController(rootViewController: accountVC)
//        accountNavController.tabBarItem = UITabBarItem(
//            title: "Account",
//            image: UIImage(named: "TabbarAccount"),
//            selectedImage: UIImage(named: "TabbarAccount")
//        )
//
//        // Tab 3: Location
//        let locationVC = UIViewController()
//        let locationNavController = UINavigationController(rootViewController: locationVC)
//        locationNavController.tabBarItem = UITabBarItem(
//            title: "Location",
//            image: UIImage(named: "TabbarLocation"),
//            selectedImage: UIImage(named: "TabbarLocation")
//        )
//
//        // Tab 4: Service
//        let serviceVC = UIViewController()
//        let serviceNavController = UINavigationController(rootViewController: serviceVC)
//        serviceNavController.tabBarItem = UITabBarItem(
//            title: "Service",
//            image: UIImage(systemName: "person.2.fill"),
//            selectedImage: UIImage(systemName: "person.2.fill")
//        )
//
//        // Add tabs to TabBarController
//        self.viewControllers = [mainNavController, accountNavController, locationNavController, serviceNavController]
//    }
//
//    private func setupTabBarAppearance() {
//        let tabBarAppearance = UITabBarAppearance()
//        tabBarAppearance.configureWithOpaqueBackground()
//        tabBarAppearance.backgroundColor = .white
//
//        // 設置圓角
//        tabBar.layer.cornerRadius = 20
//        tabBar.layer.masksToBounds = true
//        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        
//        // 設置陰影
//        tabBar.layer.shadowColor = UIColor.black.cgColor
//        tabBar.layer.shadowOpacity = 0.1
//        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
//        tabBar.layer.shadowRadius = 6
//
//        // 設置選中與未選中顏色
//        tabBar.tintColor = UIColor.orange01 // 選中顏色
//        tabBar.unselectedItemTintColor = UIColor.gray // 未選中顏色
//
//        // 設置文字字體
//        let attributes = [NSAttributedString.Key.font: Font.FavoriteName ?? UIFont.systemFont(ofSize: 12)]
//        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
//
//        tabBar.standardAppearance = tabBarAppearance
//        tabBar.scrollEdgeAppearance = tabBarAppearance
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        let height: CGFloat = 60 // 自定義 TabBar 高度
//        let width: CGFloat = view.frame.width - 40 // 減少 TabBar 寬度
//        var tabFrame = tabBar.frame
//        tabFrame.size.height = height
//        tabFrame.size.width = width
//        tabFrame.origin.y = view.frame.height - height - 20 // 懸浮效果，距離底部 20
//        tabFrame.origin.x = (view.frame.width - width) / 2 // 水平居中
//        tabBar.frame = tabFrame
//
//        // 確保圓角和陰影顯示
//        tabBar.layer.cornerRadius = 20
//        tabBar.layer.masksToBounds = false
//        tabBar.clipsToBounds = false
//    }
//}
