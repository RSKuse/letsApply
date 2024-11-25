//
//  SplashScreenViewModel.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//

import Foundation
import FirebaseAuth

class SplashScreenViewModel {

    func checkAuthentication(completion: @escaping (Bool) -> Void) {
        let isAuthenticated = Auth.auth().currentUser != nil
        completion(isAuthenticated)
    }
}
