//
//  FavoriteListViewModel.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/7.
//

import Foundation
import UIKit

class FavoriteListViewModel {
    private var favoriteItems: [FavoriteItem] = []
    var isEmpty: Bool = true
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
                self.isEmpty = self.favoriteItems.isEmpty
                DispatchQueue.main.async {
                    self.onDataUpdated?()
                }
            } catch {
                self.onError?("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
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
