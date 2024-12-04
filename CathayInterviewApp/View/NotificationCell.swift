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
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    func configure(with notification: Notification) {
        titleLabel.text = notification.title
        messageLabel.text = notification.message
        backgroundColor = notification.status ? .white : UIColor.systemYellow.withAlphaComponent(0.3)
        print("Configuring cell with notification: \(notification.title)") // 確保每個 cell 都有被正確配置
    }
    
}
