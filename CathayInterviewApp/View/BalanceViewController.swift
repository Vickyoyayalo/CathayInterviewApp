//
//  BalanceViewController.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/5.
//

import UIKit

class BalanceViewController: UIViewController {

    private let eyeButton = UIButton(type: .system)
    private let amountLabel = UILabel()
    private var isAmountHidden = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateAmountVisibility()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Balance"

        // 配置眼睛按鈕
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.tintColor = .black
        eyeButton.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eyeButton)

        // 配置金額標籤
        amountLabel.text = "********" // 默認隱藏
        amountLabel.font = .systemFont(ofSize: 24, weight: .bold)
        amountLabel.textAlignment = .center
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(amountLabel)

        // 添加約束
        NSLayoutConstraint.activate([
            eyeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            eyeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            amountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func eyeButtonTapped() {
        isAmountHidden.toggle()
        updateAmountVisibility()
    }

    private func updateAmountVisibility() {
        if isAmountHidden {
            amountLabel.text = "********"
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            amountLabel.text = "$1234.56" // 假設金額數據
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
}

