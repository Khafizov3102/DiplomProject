//
//  Position.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 08.02.2024.
//

import Foundation
import FirebaseFirestore

struct Position: Codable {
    
    var id: String
    var product: Product
    var size: String
    var count: Int
    
    var cost: Int {
        self.product.price * self.count
    }
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        
        repres["id"] = id
        repres["count"] = count
        repres["size"] = size
        repres["title"] = product.titile
        repres["price"] = product.price
        repres["cost"] = cost
        
        return repres
    }
    
    init(id: String, product: Product, size: String, count: Int) {
        self.id = id
        self.product = product
        self.size = size
        self.count = count
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        
        guard let id = data["id"] as? String else { return nil }
        guard let title = data["title"] as? String else { return nil }
        guard let price = data["price"] as? Int else { return nil }
        guard let size = data["size"] as? String else { return nil }
//        guard let isRecommend = data["isRecommend"] as? Bool else { return nil }
        let product = Product(
            id: "",
            titile: title,
            imageUrl: "",
            price: price,
            description: "", 
            isRecommend: true
        )
        guard let count = data["count"] as? Int else { return nil }
        
        self.id = id
        self.product = product
        self.count = count
        self.size = size
    }
}

enum ProductSize: String, Codable {
    case small = "Маленькая"
    case medium = "Средняя"
    case large = "Большая"
}
