//
//  GradientMaskView.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/6.
//

import UIKit

class GradientMaskView: UIView {
    private var gradientLayer: CAGradientLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    private func setupGradient() {
        gradientLayer = CAGradientLayer()
        guard let gradientLayer = gradientLayer else { return }
        gradientLayer.colors = [
            UIColor(white: 251.0 / 255.0, alpha: 1.0).cgColor,
            UIColor(white: 240.0 / 255.0, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.cornerRadius = 3.0
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
}
