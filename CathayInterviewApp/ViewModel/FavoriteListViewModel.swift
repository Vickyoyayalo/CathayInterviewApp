//
//  FavoriteListViewModel.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/7.
//

import Foundation

class FavoriteListViewModel {
    private var favoriteItems: [FavoriteItem] = []
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    var itemCount: Int {
        return favoriteItems.count
    }
    
    func item(at index: Int) -> FavoriteItem {
        return favoriteItems[index]
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
                self.favoriteItems = response.result?.favoriteList ?? []
                DispatchQueue.main.async {
                    self.onDataUpdated?() // 通知 View 刷新
                }
            } catch {
                self.onError?("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
