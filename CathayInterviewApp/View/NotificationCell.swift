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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
       
        titleLabel.font = .boldSystemFont(ofSize: 16)
       
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 2
      
        redDotView.backgroundColor = UIColor.fromHex("#FF5733")
        redDotView.layer.cornerRadius = 5
        redDotView.clipsToBounds = true
        redDotView.translatesAutoresizingMaskIntoConstraints = false
        redDotView.isHidden = true
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        contentView.addSubview(redDotView)
        
       
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
    
    func configure(with notification: Notification) {
        
        titleLabel.text = notification.title
        messageLabel.text = notification.message
      
        redDotView.isHidden = notification.status
    }
}
