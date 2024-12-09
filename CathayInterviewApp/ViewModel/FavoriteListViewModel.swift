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
    
    var itemCount: Int {
        return favoriteItems.count
    }
    
    func item(at index: Int) -> FavoriteItem? {
        return favoriteItems.indices.contains(index) ? favoriteItems[index] : nil
    }
    
    func fetchFavoriteList(isEmpty: Bool) {
        let urlString = isEmpty
        ? "https://willywu0201.github.io/data/emptyFavoriteList.json"
        : "https://willywu0201.github.io/data/favoriteList.json"
        
        guard let url = URL(string: urlString) else {
            onError?("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            if let error = error {
                self.onError?("Network error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                self.onError?("No data received")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(FavoriteResponse.self, from: data)
                var serverItems = response.result?.favoriteList ?? []
                
                self.mergeLocalOrder(with: &serverItems)
                
                self.favoriteItems = serverItems
                self.isEmpty = self.favoriteItems.isEmpty
                DispatchQueue.main.async {
                    self.onDataUpdated?()
                }
            } catch {
                self.onError?("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
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
    
    func moveItem(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex,
              sourceIndex < favoriteItems.count,
              destinationIndex < favoriteItems.count else { return }
        
        let item = favoriteItems.remove(at: sourceIndex)
        favoriteItems.insert(item, at: destinationIndex)
        
        saveCurrentOrder()
        
        onDataUpdated?()
    }
    
    private func saveCurrentOrder() {
        let itemKeys = favoriteItems.map { $0.hashKey }
        UserDefaults.standard.set(itemKeys, forKey: userDefaultsKey)
    }
    
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
