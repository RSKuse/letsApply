//
//  DashboardViewModel.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//


import Foundation
import FirebaseAuth

class DashboardViewModel {

    func logout(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            print("Error logging out: \(error.localizedDescription)")
            completion(false)
        }
    }
}
