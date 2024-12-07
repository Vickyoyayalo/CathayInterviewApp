//
//  FavoriteListView.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/7.
//

import UIKit

class FavoriteListView: UIView {
    private let titleLabel = UILabel()
    private let moreButton = UIButton(type: .system)
    private let emptyImageView = UIImageView()
    private let emptyLabel = UILabel()
    private let stackView = UIStackView()
    private let collectionView: UICollectionView

    var favoriteListViewModel: FavoriteListViewModel? {
        didSet {
            setupBindings()
        }
    }

    override init(frame: CGRect) {
        // 初始化 CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumInteritemSpacing = 16
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
       
        titleLabel.text = "My Favorite"
        titleLabel.font = Font.title
        titleLabel.textColor = .titleColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        moreButton.setTitle("More", for: .normal)
        moreButton.titleLabel?.font = Font.label
        moreButton.setTitleColor(.labelColor, for: .normal)
        moreButton.setImage(UIImage(named: "ArrowNext"), for: .normal)
        moreButton.semanticContentAttribute = .forceRightToLeft
        moreButton.configuration?.imagePadding = 8
        moreButton.translatesAutoresizingMaskIntoConstraints = false

        emptyImageView.image = UIImage(named: "ScrollEmpty")
        emptyImageView.contentMode = .scaleAspectFit
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false

        emptyLabel.text = "You can add a favorite through the transfer or payment function."
        emptyLabel.font = Font.label
        emptyLabel.textColor = .sublabelColor
        emptyLabel.numberOfLines = 0
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(emptyImageView)
        stackView.addArrangedSubview(emptyLabel)

        addSubview(titleLabel)
        addSubview(moreButton)
        addSubview(stackView)
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),

            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            moreButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),

            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])

        collectionView.dataSource = self
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: "FavoriteCell")
    }

    private func setupBindings() {
        favoriteListViewModel?.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            let isEmpty = self.favoriteListViewModel?.isEmpty ?? true
            self.stackView.isHidden = !isEmpty
            self.collectionView.isHidden = isEmpty
            self.collectionView.reloadData()
        }
    }
}

extension FavoriteListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteListViewModel?.itemCount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        if let item = favoriteListViewModel?.item(at: indexPath.row),
           let image = favoriteListViewModel?.icon(for: item.transType) {
            cell.configure(with: image, nickname: item.nickname)
        }
        return cell
    }
}
