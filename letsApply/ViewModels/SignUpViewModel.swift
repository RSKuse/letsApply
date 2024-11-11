//
//  SignUpViewModel.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/11.
//

import Foundation
import FirebaseAuth

class SignUpViewModel {
    private let firestoreService: FirestoreService

    init(firestoreService: FirestoreService = FirestoreService()) {
        self.firestoreService = firestoreService
    }

    func createUser(name: String, email: String, password: String, location: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(error)
                return
            }
            guard let user = authResult?.user else {
                completion(NSError(domain: "AuthError", code: -1, userInfo: nil))
                return
            }

            let profile = UserProfile(uid: user.uid, name: name, email: email, skills: [], location: location)
            self?.firestoreService.saveUserProfile(profile, completion: completion)
        }
    }
}
