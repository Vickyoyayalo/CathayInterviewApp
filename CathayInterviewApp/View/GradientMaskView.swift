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
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.lightGray.withAlphaComponent(0.3).cgColor,
            UIColor.lightGray.withAlphaComponent(0.1).cgColor,
            UIColor.lightGray.withAlphaComponent(0.3).cgColor
        ]
        
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.locations = [0, 0.5, 1]
        
        layer.addSublayer(gradient)
        self.gradientLayer = gradient
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }

    func startShimmer() {
        guard gradientLayer?.animation(forKey: "shimmer") == nil else { return }
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.5
        animation.repeatCount = Float.infinity
        gradientLayer?.add(animation, forKey: "shimmer")
    }

    func stopShimmer() {
        gradientLayer?.removeAnimation(forKey: "shimmer")
    }
}
