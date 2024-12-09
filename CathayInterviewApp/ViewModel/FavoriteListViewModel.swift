//
//  FavoriteListViewModel.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/7.
//

import UIKit
import Foundation

class FavoriteListViewModel {
    
    private var favoriteItems: [FavoriteItem] = []
    var isEmpty: Bool = true
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private let userDefaultsKey = "favoriteListOrder"
    
    // MARK: - Computed Properties
    
    var itemCount: Int {
        return favoriteItems.count
    }
    
    // MARK: - Item Management
    
    func item(at index: Int) -> FavoriteItem? {
        return favoriteItems.indices.contains(index) ? favoriteItems[index] : nil
    }
    
    // MARK: - Fetch Favorite List
    
    func fetchFavoriteList(isEmpty: Bool) {
        APIService.shared.fetchFavoriteList(isEmpty: isEmpty) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(var serverItems):
                    self.mergeLocalOrder(with: &serverItems)
                    self.favoriteItems = serverItems
                    self.isEmpty = self.favoriteItems.isEmpty
                    self.onDataUpdated?()
                case .failure(let error):
                    self.onError?("Network or decoding error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Merge Local Order
    
    private func mergeLocalOrder(with serverItems: inout [FavoriteItem]) {
        guard let storedOrder = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] else { return }
        
        var reorderedItems: [FavoriteItem] = []
        var remainingItems = serverItems
        
        for key in storedOrder {
            if let index = remainingItems.firstIndex(where: { $0.hashKey == key }) {
                reorderedItems.append(remainingItems.remove(at: index))
            }
        }
        
        reorderedItems.append(contentsOf: remainingItems)
        serverItems = reorderedItems
    }
    
    // MARK: - Move Item
    
    func moveItem(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex,
              sourceIndex < favoriteItems.count,
              destinationIndex < favoriteItems.count else { return }
        
        let item = favoriteItems.remove(at: sourceIndex)
        favoriteItems.insert(item, at: destinationIndex)
        
        saveCurrentOrder()
        
        onDataUpdated?()
    }
    
    // MARK: - Save Current Order
    
    private func saveCurrentOrder() {
        let itemKeys = favoriteItems.map { $0.hashKey }
        UserDefaults.standard.set(itemKeys, forKey: userDefaultsKey)
    }
    
    // MARK: - Icon For Transaction Type
    
    func icon(for transType: String) -> UIImage? {
        switch transType {
        case "CUBC": return UIImage(named: "ScrollTree")
        case "Mobile": return UIImage(named: "ScrollMobile")
        case "PMF": return UIImage(named: "ScrollBuilding")
        case "CreditCard": return UIImage(named: "ScrollCreditCard")
        default: return nil
        }
    }
}
