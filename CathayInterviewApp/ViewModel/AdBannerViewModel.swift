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
    var onDataUpdated: (() -> Void)?
    var onAutoScroll: ((Int) -> Void)?

    init() {
        loadBanners()
    }

    private func loadBanners() {
        banners = [
            UIImage(named: "banner1")!,
            UIImage(named: "banner2")!,
            UIImage(named: "banner3")!
        ]
        onDataUpdated?()
    }

    func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentIndex = (self.currentIndex + 1) % self.banners.count
            self.onAutoScroll?(self.currentIndex)
        }
    }

    func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }

    func updateCurrentPage(_ index: Int) {
        currentIndex = index
    }
}

