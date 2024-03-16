//
//  DataBaseService.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 22.01.2024.
//

import Foundation
import FirebaseFirestore

class DataBaseService {
    static let shared = DataBaseService()
    
    private let db = Firestore.firestore()
    
    private var usersReference: CollectionReference {
        return db.collection("users")
    }
    
    private var ordersReference: CollectionReference {
        return db.collection("orders")
    }
    
    private init() { }
    
    func createProfile(user: Profile, completion: @escaping(Result<Profile, Error>) -> Void) {
        usersReference.document(user.id).setData(user.representation) { error in
            if let error {
                completion(.failure(error))
                print("create user error: \(error.localizedDescription)")
            } else {
                completion(.success(user))
                print("create user success")
            }
        }
    }
    
    func getProfile(userID: String? = nil, completion: @escaping(Result<Profile, Error>) -> Void) {
        usersReference.document(userID != nil ? userID! : AuthService.shared.currentUser?.uid ?? "").getDocument { documentSnapshot, error in
            guard let data = documentSnapshot?.data() else { return }
            
            guard let userName = data["name"] as? String else { return }
            guard let id = data["id"] as? String else { return }
            guard let phone = data["phone"] as? Int else { return }
            guard let address = data["address"] as? String else { return }
            
            let user = Profile(
                id: id,
                name: userName,
                phone: phone,
                address: address
            )
            
            completion(.success(user))
        }
    }
    
    func createOrder(order: Order, completion: @escaping (Result<Order, Error>) -> Void) {
        ordersReference.document(order.id).setData(order.representation) { error in
            if let error {
                completion(.failure(error))
                print("create order error: \(error.localizedDescription)")
            } else {
                self.createPositions(
                    orderID: order.id,
                    positions: order.positions) { result in
                        switch result {
                        case .success(let positions):
                            print(positions.count)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                
                completion(.success(order))
                print("create order success")
            }
        }
        
    }
    
    func getOrders(userID: String?, completion: @escaping (Result<[Order], Error>) -> Void) {
        ordersReference.getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            var orders = [Order]()
            
            for document in documents {
                if let userID {
                    guard let order = Order(doc: document), order.userID == userID else { return }
                    orders.append(order)
                } else {
                    guard let order = Order(doc: document) else { return }
                    orders.append(order)
                }
            }
            completion(.success(orders))
            
            if let error {
                completion(.failure(error))
            }
        }
    }
    
    func createPositions(
        orderID: String,
        positions: [Position],
        completion: @escaping (Result<[Position], Error>) -> Void
    ) {
        let positionRef = ordersReference.document(orderID).collection("positions")
        
        for position in positions {
            positionRef.document(position.id).setData(position.representation)
        }
        print(positions)
        completion(.success(positions))
    }
    
    func getPositions(orderID: String, completion: @escaping (Result<[Position], Error>) -> Void) {
        let positionRef = ordersReference.document(orderID).collection("positions")
        
        positionRef.getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            var positions = [Position]()
            
            for document in documents {
                guard let position = Position(doc: document) else { return }
                positions.append(position)
            }
            
            completion(.success(positions))
            
            if let error {
                completion(.failure(error))
            }
        }
    }
}
