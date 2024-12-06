//
//  AccountBalanceView.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/5.
//

import UIKit

class AccountBalanceView: UIView {
    
    private let viewModel = AccountBalanceViewModel()
    
    private let titleLabel = UILabel()
    private let eyeButton = UIButton(type: .system)
    
    let usdLabel = UILabel()
    let khrLabel = UILabel()
    
    var onToggleVisibility: (() -> Void)?
    
    private enum Icon {
        static let hidden = "iconEye02Off"
        static let visible = "iconEye01On"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBindings()
        viewModel.fetchBalances(apiType: "firstOpen")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupBindings()
        viewModel.fetchBalances(apiType: "firstOpen")
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
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            eyeButton.widthAnchor.constraint(equalToConstant: 24),
            eyeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupBindings() {
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.usdLabel.text = self?.viewModel.usdBalance
                self?.khrLabel.text = self?.viewModel.khrBalance
                
                let imageName = self?.viewModel.isBalanceHidden == true ? Icon.hidden : Icon.visible
                self?.eyeButton.setImage(UIImage(named: imageName), for: .normal)
            }
        }
    }
    
    private func createAmountStack(title: String, valueLabel: UILabel) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Font.label
        titleLabel.textColor = UIColor.labelColor
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }
    
    @objc private func toggleVisibility() {
        viewModel.toggleBalanceVisibility()
        onToggleVisibility?()
    }
}

