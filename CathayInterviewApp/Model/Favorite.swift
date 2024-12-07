//
//  Favorite.swift
//  CathayInterviewApp
//
//  Created by Vickyhereiam on 2024/12/7.
//

import Foundation

struct FavoriteResponse: Codable {
    let msgCode: String
    let msgContent: String
    let result: ResultData?
}

struct ResultData: Codable {
    let favoriteList: [FavoriteItem]?
}

struct FavoriteItem: Codable {
    let nickname: String
    let transType: String
}
