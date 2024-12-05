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
        
        titleLabel.text = "My Account Balance"
        titleLabel.font = Font.title
        titleLabel.textColor = UIColor.titleColor

        eyeButton.setImage(UIImage(named: Icon.hidden), for: .normal)
        eyeButton.addTarget(self, action: #selector(toggleVisibility), for: .touchUpInside)

        let titleStack = UIStackView(arrangedSubviews: [titleLabel, eyeButton])
        titleStack.axis = .horizontal
        titleStack.spacing = 8
        titleStack.alignment = .center

        let usdTitleLabel = UILabel()
        usdTitleLabel.text = "USD"
        usdTitleLabel.font = Font.label
        usdTitleLabel.textColor = UIColor.labelColor

        usdLabel.text = "********"
        usdLabel.font = Font.value
        usdLabel.textColor = UIColor.labelColor

        let usdStack = UIStackView(arrangedSubviews: [usdTitleLabel, usdLabel])
        usdStack.axis = .vertical
        usdStack.spacing = 4
        usdStack.alignment = .leading

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

        let balanceStack = UIStackView(arrangedSubviews: [usdStack, khrStack])
        balanceStack.axis = .vertical
        balanceStack.spacing = 16

        let mainStack = UIStackView(arrangedSubviews: [titleStack, balanceStack])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
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

