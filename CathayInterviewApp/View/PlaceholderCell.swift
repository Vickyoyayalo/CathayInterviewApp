//
//  PlaceholderCell.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/8.
//

import UIKit
import Foundation

class PlaceholderCell: UICollectionViewCell {
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "AD"
        lbl.font = Font.emptyValue
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    
    private func setupUI() {
        // Set content view background color
        contentView.backgroundColor = UIColor(
            red: 220 / 255.0,
            green: 220 / 255.0,
            blue: 220 / 255.0,
            alpha: 1.0
        )

        // Gray view for background of label
        let grayView = UIView()
        grayView.backgroundColor = .grayViewColor
        grayView.layer.cornerRadius = 6
        grayView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(grayView)

        // Label for placeholder text
        label.translatesAutoresizingMaskIntoConstraints = false
        grayView.addSubview(label)
        
        // MARK: - Layout Constraints
        
        NSLayoutConstraint.activate([
            
            grayView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            grayView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            grayView.widthAnchor.constraint(equalToConstant: 48),
            grayView.heightAnchor.constraint(equalToConstant: 24),
            
            label.centerXAnchor.constraint(equalTo: grayView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: grayView.centerYAnchor)
        ])
    }
}
