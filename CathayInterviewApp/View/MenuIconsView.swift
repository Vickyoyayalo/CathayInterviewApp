//
//  MenuIconsView.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/6.
//

import UIKit

class MenuIconsView: UIView {

    // 默认的 iconData
    static let defaultIconData: [(icon: UIImage, title: String)] = {
        let defaultIcon = UIImage(systemName: "questionmark.circle")!
        return [
            (icon: UIImage(named: "TransferIcon") ?? defaultIcon, title: "Transfer"),
            (icon: UIImage(named: "PaymentIcon") ?? defaultIcon, title: "Payment"),
            (icon: UIImage(named: "UtilityIcon") ?? defaultIcon, title: "Utility"),
            (icon: UIImage(named: "ScanIcon") ?? defaultIcon, title: "QR Pay Scan"),
            (icon: UIImage(named: "QRcodeIcon") ?? defaultIcon, title: "My QR Code"),
            (icon: UIImage(named: "TopUpIcon") ?? defaultIcon, title: "Top Up")
        ]
    }()

    private var verticalStack: UIStackView!

    init(iconData: [(icon: UIImage, title: String)] = MenuIconsView.defaultIconData) {
        super.init(frame: .zero)
        setupView(with: iconData)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(with iconData: [(icon: UIImage, title: String)]) {
       
        let buttons = iconData.map { createIconButton(icon: $0.icon, title: $0.title) }
    
        let firstRow = createHorizontalStackView(buttons: Array(buttons[0...2]))
        let secondRow = createHorizontalStackView(buttons: Array(buttons[3...5]))
        
        verticalStack = createVerticalStackView(horizontalStacks: [firstRow, secondRow])
        
        addSubview(verticalStack)
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func createIconButton(icon: UIImage, title: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        var config = UIButton.Configuration.plain()
        config.image = icon
        config.title = title
        config.imagePlacement = .top
        config.imagePadding = 12
        config.baseForegroundColor = .black
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 14)
            return outgoing
        }
        
        button.configuration = config

        return button
    }


    private func createHorizontalStackView(buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false

        buttons.forEach { button in
            button.widthAnchor.constraint(equalToConstant: 110).isActive = true 
        }

        return stackView
    }


    private func createVerticalStackView(horizontalStacks: [UIStackView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: horizontalStacks)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}

extension MenuIconsView {
    static func withDefaultIcons() -> MenuIconsView {
        return MenuIconsView(iconData: defaultIconData)
    }
}
