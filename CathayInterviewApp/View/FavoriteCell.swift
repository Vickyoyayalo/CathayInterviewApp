//
//  FavoriteCell.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/7.
//

import UIKit

class FavoriteCell: UITableViewCell {
    private let nicknameLabel = UILabel()
    private let transTypeImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        transTypeImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(nicknameLabel)
        contentView.addSubview(transTypeImageView)

        NSLayoutConstraint.activate([
            transTypeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            transTypeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            transTypeImageView.widthAnchor.constraint(equalToConstant: 40),
            transTypeImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nicknameLabel.leadingAnchor.constraint(equalTo: transTypeImageView.trailingAnchor, constant: 16),
            nicknameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nicknameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with item: FavoriteItem) {
        nicknameLabel.text = item.nickname
        transTypeImageView.image = UIImage(named: item.transType) // Map icons to names
    }
}

