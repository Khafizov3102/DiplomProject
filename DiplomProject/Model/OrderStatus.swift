//
//  OrderStatus.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 20.04.2024.
//

import Foundation

enum OrderStatus: String, CaseIterable {
    case new = "Новый"
    case cooking = "Готовится"
    case delivery = "Доставляется"
    case completed = "Выполнен"
    case cancelled = "Отменен"
}
