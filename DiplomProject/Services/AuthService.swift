//
//  AuthService.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 14.01.2024.
//

import Foundation
import Firebase

class AuthService {
    static let shared = AuthService()
    
    private init() { }
    
    private let auth = Auth.auth()
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    func signUp(email: String, password: String, completion: @escaping(Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let result {
                let userInfo = Profile(
                    id: result.user.uid,
                    name: "",
                    phone: "",
                    address: ""
                )
                
                DataBaseService.shared.createProfile(user: userInfo) { resultDB in
                    switch resultDB {
                    case .success(_):
                        completion(.success(result.user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }

                
                completion(.success(result.user))
            } else if let error {
                completion(.failure(error))
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping(Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let result {
                completion(.success(result.user))
            } else if let error {
                completion(.failure(error))
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func isUserLogin(completion: @escaping(Result<User, Error>) -> Void) {
        auth.addStateDidChangeListener { auth, user in
            if let user {
                completion(.success(user))
            }
        }
    }
}
