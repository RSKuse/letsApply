//
//  FirebaseAuthenticationService.swift
//  letsApply
//
//  Created by Gugulethu Mhlanga on 2024/11/19.
//

import Foundation
import FirebaseAuth

class FirebaseAuthenticationService {
    
    static let shared = FirebaseAuthenticationService(
    
    /**
     Email Sign Up
     */
    func signUp(email: String,
                password: String,
                completion: @escaping (Error?) -> Void) {
        
    }
    
    /**
     Email Sign In
     */
    func signIn(email: String,
                password: String,
                completion: @escaping (Result<UserProfile, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = authResult?.user else {
                completion(.failure(NSError(domain: "AuthError", code: AuthErrorCode.userNotFound.rawValue, userInfo: nil)))
                return
            }
            FirestoreService().fetchUserProfile(uid: user.uid, completion: completion)
        }
    }

    func resetPassword(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
    
    func logout() {
        
    }
}
