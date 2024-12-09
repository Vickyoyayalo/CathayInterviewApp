//
//  AdBannerView.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/8.
//

import UIKit

class AdBannerView: UIView {
    
    internal let collectionView: UICollectionView
    private let pageControl = UIPageControl()
    
    var viewModel: AdBannerViewModel? {
        didSet {
            setupBindings()
            viewModel?.onDataUpdated?()
        }
    }
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        super.init(frame: frame)
        
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: collectionView.bounds.width, height: 120)
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
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
            pageControl.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -4),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        collectionView.layer.cornerRadius = 12
        collectionView.clipsToBounds = true
        collectionView.layer.shadowColor = UIColor.black.cgColor
        collectionView.layer.shadowOpacity = 0.1
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        collectionView.layer.shadowRadius = 4
        
        pageControl.numberOfPages = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: "BannerCell")
        collectionView.register(PlaceholderCell.self, forCellWithReuseIdentifier: "PlaceholderCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceHorizontal = true
    }
    
    private func setupBindings() {
        viewModel?.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                let count = self?.viewModel?.banners.count ?? 0
                self?.pageControl.numberOfPages = count
                self?.pageControl.currentPage = 0
            }
        }
        
        viewModel?.onAutoScroll = { [weak self] nextIndex in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let indexPath = IndexPath(item: nextIndex, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.pageControl.currentPage = nextIndex
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
        let count = viewModel?.banners.count ?? 0
        return count == 0 ? 1 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let count = viewModel?.banners.count ?? 0
        if count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
            if let banner = viewModel?.banners[indexPath.item] {
                cell.configure(with: banner)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath) as! PlaceholderCell
            return cell
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = pageIndex
        viewModel?.updateCurrentPage(pageIndex)
        
        viewModel?.stopAutoScroll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.viewModel?.startAutoScroll()
        }
    }
}
