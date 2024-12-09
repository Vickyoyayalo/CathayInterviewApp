//
//  FavoriteCell.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/7.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
   
    private let imageView = UIImageView()
    private let label = UILabel()
    
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
       
        imageView.translatesAutoresizingMaskIntoConstraints = false
     
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.favoriteName
        label.textColor = .sublabelColor
        label.textAlignment = .center
        label.numberOfLines = 2
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
 
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    // MARK: - Configure Cell
    
    func configure(with image: UIImage, nickname: String) {
        imageView.image = image
        label.text = nickname
    }
}
