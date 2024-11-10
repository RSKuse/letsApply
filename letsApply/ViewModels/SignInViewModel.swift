//
//  SignInViewModel.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/11.
//

import Foundation
import FirebaseAuth

class SignInViewModel {
    func signIn(email: String, password: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = authResult?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: nil)))
                return
            }
            FirestoreService().fetchUserProfile(uid: user.uid, completion: completion)
        }
    }

    func resetPassword(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
}
