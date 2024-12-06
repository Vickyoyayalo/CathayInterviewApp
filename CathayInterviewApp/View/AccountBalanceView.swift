//
//  AccountBalanceView.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/5.
//

import UIKit

class AccountBalanceView: UIView {
    var viewModel: AccountBalanceViewModel? {
        didSet {
            setupBindings()
        }
    }
    
    var onToggleVisibility: (() -> Void)?
    var onRefreshComplete: (() -> Void)?
    
    private let titleLabel = UILabel()
    private let eyeButton = UIButton(type: .system)
    let usdLabel = UILabel()
    let khrLabel = UILabel()
    
    private enum Icon {
        static let hidden = "iconEye02Off"
        static let visible = "iconEye01On"
    }
    
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
        guard let viewModel = viewModel else {
            return
        }
    
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.usdLabel.text = viewModel.usdBalance
                self.khrLabel.text = viewModel.khrBalance
                
                let imageName = viewModel.isBalanceHidden ? Icon.hidden : Icon.visible
                self.eyeButton.setImage(UIImage(named: imageName), for: .normal)
                
                self.onRefreshComplete?()
            }
        }
    }
    
    @objc private func toggleVisibility() {
        viewModel?.toggleBalanceVisibility()
        onToggleVisibility?()
    }
}
