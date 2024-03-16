//
//  StorageManager.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 10.02.2024.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let positionKey = "positions"
    
    private init() {}
        
    func save(position: Position) {
        var positions = fetchPositions()
        positions.append(position)
        
        guard let data = try? JSONEncoder().encode(positions) else { return }
        
        userDefaults.set(data, forKey: positionKey)
    }
    
    func fetchPositions() -> [Position] {
        guard let data = userDefaults.data(forKey: positionKey) else { return [] }
        
        guard let positions = try? JSONDecoder().decode([Position].self, from: data) else { return [] }
        return positions
    }
    
    func deletePosition(at index: Int) {
        var positions = fetchPositions()
        positions.remove(at: index)
        
        guard let data = try? JSONEncoder().encode(positions) else { return }
        userDefaults.set(data, forKey: positionKey)
    }
    
    func deletePositions() -> [Position] {
        let positions: [Position] = []
        
        guard let data = try? JSONEncoder().encode(positions) else { return positions }
        userDefaults.set(data, forKey: positionKey)
        return positions
    }
}
