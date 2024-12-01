//
//  DashboardViewModel.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//


import Foundation
import FirebaseAuth

class DashboardViewModel {

    private let firestoreService = FirestoreService()
    
    var greetingMessage: String = "Welcome, Guest!" // Default value
    
    func fetchGreeting(completion: @escaping (String) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion("Welcome, Guest!")
            return
        }
        
        firestoreService.fetchUserProfile(uid: user.uid) { result in
            switch result {
            case .success(let profile):
                completion("Welcome, \(profile.name)!")
            case .failure:
                completion("Welcome, Guest!")
            }
        }
    }
}
