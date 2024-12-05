//
//  AccountBalanceViewController.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/5.
//

import UIKit

class AccountBalanceViewController: UIView {
    
    private let titleLabel = UILabel()
    private let usdLabel = UILabel()
    private let khrLabel = UILabel()
    private let eyeButton = UIButton(type: .system)

    private var isBalanceHidden = true

    private enum Icon {
        static let hidden = "iconEye02Off"
        static let visible = "iconEye01On"
    }

    var onToggleVisibility: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        // 設置標題樣式
        titleLabel.text = "My Account Balance"
        titleLabel.font = Font.title
        titleLabel.textColor = UIColor.titleColor

        // 設置眼睛按鈕
        eyeButton.setImage(UIImage(named: Icon.hidden), for: .normal)
        eyeButton.addTarget(self, action: #selector(toggleVisibility), for: .touchUpInside)

        // 水平堆疊標題與按鈕
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, eyeButton])
        titleStack.axis = .horizontal
        titleStack.spacing = 8
        titleStack.alignment = .center

        // 設置 USD 標籤
        let usdTitleLabel = UILabel()
        usdTitleLabel.text = "USD"
        usdTitleLabel.font = Font.label // 使用 Font 管理器
        usdTitleLabel.textColor = UIColor.labelColor // 使用顏色管理器

        usdLabel.text = "********"
        usdLabel.font = Font.value // 使用 Font 管理器
        usdLabel.textColor = UIColor.labelColor // 使用顏色管理器

        let usdStack = UIStackView(arrangedSubviews: [usdTitleLabel, usdLabel])
        usdStack.axis = .vertical
        usdStack.spacing = 4
        usdStack.alignment = .leading

        // 設置 KHR 標籤
        let khrTitleLabel = UILabel()
        khrTitleLabel.text = "KHR"
        khrTitleLabel.font = Font.label
        khrTitleLabel.textColor = UIColor.labelColor

        khrLabel.text = "********"
        khrLabel.font = Font.value
        khrLabel.textColor = UIColor.labelColor

        let khrStack = UIStackView(arrangedSubviews: [khrTitleLabel, khrLabel])
        khrStack.axis = .vertical
        khrStack.spacing = 4
        khrStack.alignment = .leading

        // 垂直堆疊金額部分
        let balanceStack = UIStackView(arrangedSubviews: [usdStack, khrStack])
        balanceStack.axis = .vertical
        balanceStack.spacing = 16

        // 整體堆疊
        let mainStack = UIStackView(arrangedSubviews: [titleStack, balanceStack])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainStack)

        // 添加約束
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -110),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            eyeButton.widthAnchor.constraint(equalToConstant: 24),
            eyeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    @objc private func toggleVisibility() {
        // 切換隱藏狀態
        isBalanceHidden.toggle()

        // 切換按鈕圖標
        let imageName = isBalanceHidden ? Icon.hidden : Icon.visible
        eyeButton.setImage(UIImage(named: imageName), for: .normal)

        // 更新金額顯示
        usdLabel.text = isBalanceHidden ? "********" : "12,345.67"
        khrLabel.text = isBalanceHidden ? "********" : "4,000,000.00"

        onToggleVisibility?()
    }
}

//import UIKit
//
//class AccountBalanceViewController: UIView {
//    
//    private let titleLabel = UILabel()
//    private let eyeButton = UIButton(type: .system)
//
//    private let usdTitleLabel = UILabel()
//    private let usdValueLabel = UILabel()
//    private let khrTitleLabel = UILabel()
//    private let khrValueLabel = UILabel()
//
//    private var isBalanceHidden = true
//
//    private enum Icon {
//        static let hidden = "iconEye02Off"
//        static let visible = "iconEye01On"
//    }
//
//    var onToggleVisibility: (() -> Void)?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupUI()
//    }
//
//    private func setupUI() {
//       
//        titleLabel.text = "My Account Balance"
//        titleLabel.font = UIFont(name: "SFProText-Regular", size: 18)
//        titleLabel.textColor = UIColor(named: "gray5")
//
//        eyeButton.setImage(UIImage(named: Icon.hidden), for: .normal)
//        eyeButton.addTarget(self, action: #selector(toggleVisibility), for: .touchUpInside)
//
//        let titleStack = UIStackView(arrangedSubviews: [titleLabel, eyeButton])
//        titleStack.axis = .horizontal
//        titleStack.spacing = 8
//        titleStack.alignment = .center
//
//        usdTitleLabel.text = "USD"
//        usdTitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
//        usdTitleLabel.textColor = UIColor.fromHex("#555555")
//
//        usdValueLabel.text = "********"
//        usdValueLabel.font = .systemFont(ofSize: 24, weight: .bold)
//        usdValueLabel.textColor = UIColor.fromHex("#555555")
//
//        // USD 垂直堆疊
//        let usdStack = UIStackView(arrangedSubviews: [usdTitleLabel, usdValueLabel])
//        usdStack.axis = .vertical
//        usdStack.spacing = 4
//        usdStack.alignment = .leading // 金額左對齊
//
//        // 設置 KHR 標籤
//        khrTitleLabel.text = "KHR"
//        khrTitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
//        khrTitleLabel.textColor = UIColor.fromHex("#555555")
//
//        khrValueLabel.text = "********"
//        khrValueLabel.font = .systemFont(ofSize: 24, weight: .bold)
//        khrValueLabel.textColor = UIColor.fromHex("#555555")
//
//        // KHR 垂直堆疊
//        let khrStack = UIStackView(arrangedSubviews: [khrTitleLabel, khrValueLabel])
//        khrStack.axis = .vertical
//        khrStack.spacing = 4
//        khrStack.alignment = .leading // 金額左對齊
//
//        // 金額整體垂直堆疊
//        let balanceStack = UIStackView(arrangedSubviews: [usdStack, khrStack])
//        balanceStack.axis = .vertical
//        balanceStack.spacing = 16
//
//        // 整體垂直堆疊
//        let mainStack = UIStackView(arrangedSubviews: [titleStack, balanceStack])
//        mainStack.axis = .vertical
//        mainStack.spacing = 16
//        mainStack.translatesAutoresizingMaskIntoConstraints = false
//
//        // 添加到主視圖
//        addSubview(mainStack)
//
//        // 設置約束
//        NSLayoutConstraint.activate([
//            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
//            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
//            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -120),
//            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//
//        // 限制按鈕大小
//        NSLayoutConstraint.activate([
//            eyeButton.widthAnchor.constraint(equalToConstant: 24),
//            eyeButton.heightAnchor.constraint(equalToConstant: 24)
//        ])
//    }
//
//    @objc private func toggleVisibility() {
//        // 切換顯示狀態
//        isBalanceHidden.toggle()
//
//        // 切換按鈕圖標
//        let imageName = isBalanceHidden ? Icon.hidden : Icon.visible
//        eyeButton.setImage(UIImage(named: imageName), for: .normal)
//
//        // 更新金額顯示
//        usdValueLabel.text = isBalanceHidden ? "********" : "12,345.67"
//        khrValueLabel.text = isBalanceHidden ? "********" : "4,000,000.00"
//
//        onToggleVisibility?()
//    }
//}
//
