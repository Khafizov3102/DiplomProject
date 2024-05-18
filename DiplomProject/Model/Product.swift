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
    var isRecommend: Bool
    
    static func fetchData() -> [Product] {
        [
            Product(id: "1", titile: "Пепперони", imageUrl: "1", price: 399, description: "Пикантная пепперони, увеличенная порция моцареллы, томаты, фирменный томатный соус", isRecommend: true),
            Product(id: "2", titile: "Двойной цыпленок", imageUrl: "2", price: 349, description: "Цыпленок, моцарелла, фирменный соус альфредо", isRecommend: false),
            Product(id: "3", titile: "Ветчина и сыр", imageUrl: "3", price: 349, description: "Ветчина, моцарелла, фирменный соус альфредо", isRecommend: true),
            Product(id: "4", titile: "Чоризо фреш", imageUrl: "4", price: 289, description: "Острые колбаски чоризо, сладкий перец, моцарелла, фирменный томатный соус", isRecommend: false),
            Product(id: "5", titile: "Пицца Жюльен", imageUrl: "5", price: 429, description: "Цыпленок, шампиньоны, грибной соус, лук, сухой чеснок, моцарелла, смесь сыров чеддер и пармезан,  соус альфредо", isRecommend: false),
            Product(id: "6", titile: "Баварская", imageUrl: "6", price: 429, description: "Баварские колбаски, маринованные огурчики, красный лук, томаты, горчичный соус, моцарелла, фирменный томатный соус", isRecommend: false),
            Product(id: "7", titile: "Маргарита", imageUrl: "6", price: 399, description: "Увеличенная порция моцареллы, томаты, итальянские травы, фирменный томатный соус", isRecommend: true),
            Product(id: "8", titile: "Гавайская", imageUrl: "7", price: 399, description: "Двойная порция цыпленка, ананасы, моцарелла, фирменный соус альфредо", isRecommend: true),
        ]
    }
}
