//
//  AccountBalanceView.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/5.
//

import UIKit

class AccountBalanceView: UIView {
    
    private let usdMaskView = GradientMaskView()
    private let khrMaskView = GradientMaskView()
    
    var viewModel: AccountBalanceViewModel? {
        didSet {
            setupBindings()
            refreshUI()
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
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup UI
    
    private func setupUI() {
        
        // Title Section
        titleLabel.text = "My Account Balance"
        titleLabel.font = Font.title
        titleLabel.textColor = UIColor.titleColor
        
        eyeButton.setImage(UIImage(named: Icon.hidden), for: .normal)
        eyeButton.addTarget(self, action: #selector(toggleVisibility), for: .touchUpInside)
        
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, eyeButton])
        titleStack.axis = .horizontal
        titleStack.spacing = 8
        titleStack.alignment = .center
        
        // USD Balance Section
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
        
        // KHR Balance Section
        let khrTitleLabel = UILabel()
        khrTitleLabel.text = "KHR"
        khrTitleLabel.font = Font.label
        khrTitleLabel.textColor = UIColor.labelColor
        
        khrLabel.text = "********"
        khrLabel.font = Font.value
        khrLabel.textColor = UIColor.labelColor
        khrLabel.lineBreakMode = .byClipping
        khrLabel.adjustsFontSizeToFitWidth = true
        khrLabel.minimumScaleFactor = 0.8
        
        let khrStack = UIStackView(arrangedSubviews: [khrTitleLabel, khrLabel])
        khrStack.axis = .vertical
        khrStack.spacing = 4
        khrStack.alignment = .leading
        
        // Balance Stack
        let balanceStack = UIStackView(arrangedSubviews: [usdStack, khrStack])
        balanceStack.axis = .vertical
        balanceStack.spacing = 16
        
        // Main Stack
        let mainStack = UIStackView(arrangedSubviews: [titleStack, balanceStack])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            eyeButton.widthAnchor.constraint(equalToConstant: 24),
            eyeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        usdLabel.addSubview(usdMaskView)
        khrLabel.addSubview(khrMaskView)

        usdMaskView.translatesAutoresizingMaskIntoConstraints = false
        khrMaskView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usdMaskView.topAnchor.constraint(equalTo: usdLabel.topAnchor),
            usdMaskView.leadingAnchor.constraint(equalTo: usdLabel.leadingAnchor),
            usdMaskView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            usdMaskView.heightAnchor.constraint(equalToConstant: 40),
            
            khrMaskView.topAnchor.constraint(equalTo: khrLabel.topAnchor),
            khrMaskView.leadingAnchor.constraint(equalTo: khrLabel.leadingAnchor),
            khrMaskView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            khrMaskView.heightAnchor.constraint(equalToConstant: 40),
            khrMaskView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -4)
        ])
    }

    // MARK: - Setup Bindings
    
    private func setupBindings() {
        guard let viewModel = viewModel else { return }
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.refreshUI()
                self?.onRefreshComplete?()
            }
        }
    }
    
    // MARK: - UI Refresh
    
    private func refreshUI() {
        guard let viewModel = viewModel else { return }
        
        usdLabel.text = viewModel.usdBalance
        khrLabel.text = viewModel.khrBalance
        
        if viewModel.isBalanceHidden {
            if viewModel.isFirstOpen {
                usdMaskView.isHidden = false
                khrMaskView.isHidden = false
                eyeButton.setImage(UIImage(named: Icon.hidden), for: .normal)
                startShimmer()
            } else {
                usdLabel.text = "********"
                khrLabel.text = "********"
                usdMaskView.isHidden = true
                khrMaskView.isHidden = true
                eyeButton.setImage(UIImage(named: Icon.hidden), for: .normal)
                stopShimmer()
            }
        } else {
            usdMaskView.isHidden = true
            khrMaskView.isHidden = true
            eyeButton.setImage(UIImage(named: Icon.visible), for: .normal)
            stopShimmer()
        }
    }

    // MARK: - Actions
    
    @objc private func toggleVisibility() {
        viewModel?.toggleBalanceVisibility()
        onToggleVisibility?()
    }
    
    // MARK: - Shimmer Effect
    
    private func startShimmer() {
        usdMaskView.startShimmer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.khrMaskView.startShimmer()
        }
    }

    private func stopShimmer() {
        usdMaskView.stopShimmer()
        khrMaskView.stopShimmer()
    }
}
