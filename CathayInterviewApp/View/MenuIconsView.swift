//
//  MenuIconsView.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/6.
//

import UIKit

class MenuIconsView: UIView {

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

    // MARK: - Initializers
    
    init(iconData: [(icon: UIImage, title: String)] = MenuIconsView.defaultIconData) {
        super.init(frame: .zero)
        setupView(with: iconData)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup View
    
    private func setupView(with iconData: [(icon: UIImage, title: String)]) {
        let buttons = iconData.map { createIconButton(icon: $0.icon, title: $0.title) }
    
        // Create horizontal stacks for button layout
        let firstRow = createHorizontalStackView(buttons: Array(buttons[0...2]))
        let secondRow = createHorizontalStackView(buttons: Array(buttons[3...5]))
        
        // Create vertical stack to hold the horizontal stacks
        verticalStack = createVerticalStackView(horizontalStacks: [firstRow, secondRow])
        
        addSubview(verticalStack)
        
        // MARK: - Layout Constraints
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Create Icon Button
    
    private func createIconButton(icon: UIImage, title: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        var config = UIButton.Configuration.plain()
        config.image = icon
        config.title = title
        config.imagePlacement = .top
        config.imagePadding = 12
        config.baseForegroundColor = UIColor(named: "gray7") ?? .black

        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = Font.emptyValue ?? UIFont.systemFont(ofSize: 14)
            return outgoing
        }
        
        button.configuration = config
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.adjustsFontForContentSizeCategory = true

        return button
    }

    // MARK: - Create Horizontal Stack View
    
    private func createHorizontalStackView(buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    // MARK: - Create Vertical Stack View
    
    private func createVerticalStackView(horizontalStacks: [UIStackView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: horizontalStacks)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}

// MARK: - Extensions: Factory Method for Default Icons
extension MenuIconsView {
    static func withDefaultIcons() -> MenuIconsView {
        return MenuIconsView(iconData: defaultIconData)
    }
}
