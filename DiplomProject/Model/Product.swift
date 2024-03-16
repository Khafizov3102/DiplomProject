//
//  Product.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 30.01.2024.
//

import Foundation

struct Product: Codable {
    var id: String
    var titile: String
    var imageUrl: String
    var price: Int
    var description: String
    
//    var orderCount: Int
//    var isRecommend: Bool
    
    static func fetchData() -> [Product] {
        [
        Product(id: "1", titile: "4 Сыра", imageUrl: "pizza", price: 500, description: "Сырная пицца"),
        Product(id: "2", titile: "Диабло", imageUrl: "pizza", price: 700, description: "Острая пицца"),
        Product(id: "3", titile: "3-я пицца", imageUrl: "pizza", price: 500, description: "3-я пицца"),
        Product(id: "4", titile: "4-я пицца", imageUrl: "pizza", price: 400, description: "4-я пицца"),
        Product(id: "5", titile: "5-я пицца", imageUrl: "pizza", price: 600, description: "5-я пицца"),
        Product(id: "6", titile: "6-я пицца", imageUrl: "pizza", price: 5700, description: "6-я пицца"),
        Product(id: "7", titile: "7-я пицца", imageUrl: "pizza", price: 5600, description: "7-я пицца"),
        ]
    }
}
