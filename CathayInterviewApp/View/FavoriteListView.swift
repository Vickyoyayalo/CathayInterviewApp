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
    
    private var currentPage = 0
    
    var favoriteListViewModel: FavoriteListViewModel? {
        didSet {
            setupBindings()
        }
    }
    
    override init(frame: CGRect) {
        
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
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
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
        moreButton.addTarget(self, action: #selector(handleMoreButtonTapped), for: .touchUpInside)
        
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
        collectionView.delegate = self
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
    
    @objc private func handleMoreButtonTapped() {
        guard let itemCount = favoriteListViewModel?.itemCount, itemCount > 0 else { return }
        
        // 取得每一頁的 item 數量 (您說每頁顯示 4 個)
        let itemsPerPage = 4
        let totalPages = Int(ceil(Double(itemCount) / Double(itemsPerPage)))
        
        // 計算下一頁的 index，如果已經是最後一頁，則回到第一頁
        currentPage = (currentPage + 1) % totalPages
        let nextIndex = currentPage * itemsPerPage
        
        if nextIndex < itemCount {
            let indexPath = IndexPath(item: nextIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
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
    
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return
            }
            guard let count = favoriteListViewModel?.itemCount, count > 4 else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
}

extension FavoriteListView: UICollectionViewDelegate {
  
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        guard let count = favoriteListViewModel?.itemCount else { return false }
        return count > 4
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        favoriteListViewModel?.moveItem(from: sourceIndexPath.item, to: destinationIndexPath.item)
    }
}
