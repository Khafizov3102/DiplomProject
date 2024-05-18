//
//  Order.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 18.02.2024.
//

import Foundation
import FirebaseFirestore

struct Order {
    var id: String
    var userID: String
    var positions = [Position]()
    var date: Date
    var status: String
    var paymentMethod: String
    
    var cost: Int {
        var sum = 0
        for position in positions {
            sum += position.cost
        }
        return sum
    }
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = id
        repres["userID"] = userID
        repres["date"] = Timestamp(date: date)
        repres["status"] = status
        repres["paymentMethod"] = paymentMethod
        
        return repres
    }
    
    init(id: String = UUID().uuidString, userID: String, positions: [Position] = [Position](), date: Date, status: String, paymentMethod: String) {
        self.id = id
        self.userID = userID
        self.positions = positions
        self.date = date
        self.status = status
        self.paymentMethod = paymentMethod
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        
        guard let id = data["id"] as? String else { return nil }
        guard let userID = data["userID"] as? String else { return nil }
        guard let date = data["date"] as? Timestamp else { return nil }
        guard let status = data["status"] as? String else { return nil }
        guard let paymentMethod = data["paymentMethod"] as? String else { return nil }
        
        self.id = id
        self.userID = userID
        self.date = date.dateValue()
        self.status = status
        self.paymentMethod = paymentMethod
    }
}

