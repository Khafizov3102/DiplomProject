//
//  UserInfo.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 22.01.2024.
//

import Foundation

struct Profile: Identifiable {
    var id: String
    var name: String
    var phone: String
    var address: String
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = id
        repres["name"] = name
        repres["phone"] = phone
        repres["address"] = address
        
        return repres
    }
}
