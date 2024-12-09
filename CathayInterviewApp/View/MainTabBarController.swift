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
      
        let mainVC = MainViewController()
        mainVC.view.backgroundColor = .white
        let mainNavController = UINavigationController(rootViewController: mainVC)
        mainNavController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "TabbarHomeActive"),
            selectedImage: UIImage(named: "TabbarHomeActive")?.withRenderingMode(.alwaysOriginal)
            
        )

        let accountVC = UIViewController()
        accountVC.view.backgroundColor = .white
        let accountNavController = UINavigationController(rootViewController: accountVC)
        accountNavController.tabBarItem = UITabBarItem(
            title: "Account",
            image: UIImage(named: "TabbarAccount")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "TabbarAccount")
        )

        let locationVC = UIViewController()
        locationVC.view.backgroundColor = .white
        let locationNavController = UINavigationController(rootViewController: locationVC)
        locationNavController.tabBarItem = UITabBarItem(
            title: "Location",
            image: UIImage(named: "TabbarLocation")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "TabbarLocation")
        )

        let serviceVC = UIViewController()
        serviceVC.view.backgroundColor = .white
        let serviceNavController = UINavigationController(rootViewController: serviceVC)
        serviceNavController.tabBarItem = UITabBarItem(
            title: "Service",
            image: UIImage(systemName: "person.2.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(named: "gray7")!),
            selectedImage: UIImage(systemName: "person.2.fill")
        )
        self.viewControllers = [mainNavController, accountNavController, locationNavController, serviceNavController]
    }
    
    private func setupTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .clear
        
        tabBarAppearance.shadowColor = .clear

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: Font.tabbarItem ?? UIFont.systemFont(ofSize: 12, weight: .bold),
            .foregroundColor: UIColor.labelColor ?? UIColor.systemGray6
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: Font.tabbarItem ?? UIFont.systemFont(ofSize: 12, weight: .bold),
            .foregroundColor: UIColor.orange01
        ]

        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes

        tabBarAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 3)
        tabBarAppearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 3)
    
        tabBar.tintColor = .orange01
        tabBar.unselectedItemTintColor = .labelColor

        let radius: CGFloat = 30
        let size = CGSize(width: UIScreen.main.bounds.width - 40, height: 70)

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.white.cgColor)
        let rect = CGRect(origin: .zero, size: size)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        path.addClip()
        context.fill(rect)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let bgImage = roundedImage {
            tabBarAppearance.backgroundImage = bgImage
        }
        tabBarAppearance.backgroundEffect = nil

        tabBar.standardAppearance = tabBarAppearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }

    }
    
    private func setupTabBarBackground() {
        tabBarBackgroundView = UIView()
        tabBarBackgroundView.backgroundColor = .white
        tabBarBackgroundView.layer.cornerRadius = 30
        tabBarBackgroundView.layer.shadowColor = UIColor.black.cgColor
        tabBarBackgroundView.layer.shadowOpacity = 0.2
        tabBarBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 5)
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

        let tabBarHeight: CGFloat = 60
        let tabBarHorizontalPadding: CGFloat = 80
        let tabBarWidth = view.frame.width - tabBarHorizontalPadding

        var tabFrame = tabBar.frame
        tabFrame.size.height = tabBarHeight
        tabFrame.size.width = tabBarWidth
        tabFrame.origin.y = view.frame.height - tabBarHeight - 20
        tabFrame.origin.x = (view.frame.width - tabBarWidth) / 2
        tabBar.frame = tabFrame

        let backgroundHeight: CGFloat = 60
        let backgroundHorizontalPadding: CGFloat = 48
        let backgroundWidth = view.frame.width - backgroundHorizontalPadding

        tabBarBackgroundView.frame = CGRect(
            x: (view.frame.width - backgroundWidth) / 2,
            y: view.frame.height - backgroundHeight - 20,
            width: backgroundWidth,
            height: backgroundHeight
        )
    }
}
