//
//  NotificationCell.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/4.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    static let identifier = "NotificationCell"

    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let redDotView = UIView()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
       
        contentView.backgroundColor = UIColor.fromHex("#F5F5F5")
        
        // Title Label
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        // Message Label
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 2
      
        // Red Dot View
        redDotView.backgroundColor = UIColor.fromHex("#FF5733")
        redDotView.layer.cornerRadius = 5
        redDotView.clipsToBounds = true
        redDotView.translatesAutoresizingMaskIntoConstraints = false
        redDotView.isHidden = true
        
        // Stack View for Title and Message
        let stackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        contentView.addSubview(redDotView)
        
        // MARK: - Layout Constraints
        NSLayoutConstraint.activate([
           
            redDotView.widthAnchor.constraint(equalToConstant: 10),
            redDotView.heightAnchor.constraint(equalToConstant: 10),
            redDotView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            redDotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: redDotView.trailingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    // MARK: - Configure Cell
    
    func configure(with notification: Notification) {
        titleLabel.text = notification.title
        messageLabel.text = notification.message
        redDotView.isHidden = notification.status
    }
}
