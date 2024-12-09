//
//  AdBannerViewModel.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/8.
//

import UIKit

class AdBannerViewModel {

    var banners: [UIImage] = []
    private var timer: Timer?
    private var currentIndex = 0
    var isFirstLoad: Bool = true
    
    // MARK: - Callbacks
    
    var onDataUpdated: (() -> Void)?
    var onAutoScroll: ((Int) -> Void)?
    
    // MARK: - Load Banners with Placeholder
    
    func loadBannersWithPlaceholder() {
        isFirstLoad = true
        banners = []
        onDataUpdated?()
    }
    
    // MARK: - Load Banners
    
    func loadBanners() {
        banners = [
            UIImage(named: "banner1")!,
            UIImage(named: "banner2")!,
            UIImage(named: "banner3")!,
            UIImage(named: "banner4")!,
            UIImage(named: "banner5")!
        ]
        onDataUpdated?()
    }
    
    // MARK: - Start Auto Scroll
    
    func startAutoScroll() {
        stopAutoScroll()
        
        guard banners.count > 1 else {
            print("Not enough banners to auto-scroll")
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self, !self.banners.isEmpty else { return }
            self.currentIndex = (self.currentIndex + 1) % self.banners.count
            self.onAutoScroll?(self.currentIndex)
        }
    }
    
    // MARK: - Stop Auto Scroll
    
    func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Update Current Page
    
    func updateCurrentPage(_ index: Int) {
        currentIndex = index
    }
}
