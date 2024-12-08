//
//  AdBannerView.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/8.
//

import UIKit

class AdBannerView: UIView {
    private let collectionView: UICollectionView
    private let pageControl = UIPageControl()
    
    var viewModel: AdBannerViewModel? {
        didSet {
            setupBindings()
        }
    }

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 48, height: 120)
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(collectionView)
        addSubview(pageControl)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 120),

            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 4),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])

        collectionView.layer.cornerRadius = 12
        collectionView.clipsToBounds = true
        collectionView.layer.shadowColor = UIColor.black.cgColor
        collectionView.layer.shadowOpacity = 0.1
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        collectionView.layer.shadowRadius = 4

        pageControl.numberOfPages = viewModel?.banners.count ?? 0
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: "BannerCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupBindings() {
        viewModel?.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.pageControl.numberOfPages = self?.viewModel?.banners.count ?? 0
            }
        }

        viewModel?.onAutoScroll = { [weak self] nextIndex in
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: nextIndex, section: 0)
                self?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self?.pageControl.currentPage = nextIndex
            }
        }
    }

    func startAutoScroll() {
        viewModel?.startAutoScroll()
    }

    func stopAutoScroll() {
        viewModel?.stopAutoScroll()
    }
}

extension AdBannerView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.banners.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
        if let banner = viewModel?.banners[indexPath.item] {
            cell.configure(with: banner)
        }
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = pageIndex
        viewModel?.updateCurrentPage(pageIndex)
    }
}

// BannerCell
class BannerCell: UICollectionViewCell {
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 在 BannerCell 的 configure 方法中，設置圖片的縮放模式
    func configure(with image: UIImage) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit // 確保圖片自適應顯示
    }

}

