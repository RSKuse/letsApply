//
//  ProfileSetupViewModel.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/11.
//

import Foundation
import FirebaseAuth

class ProfileSetupViewModel {
    private let firestoreService: FirestoreService
    private(set) var userProfile: UserProfile?

    init(firestoreService: FirestoreService = FirestoreService()) {
        self.firestoreService = firestoreService
    }

    func fetchUserProfile(completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(NSError(domain: "AuthError", code: -1, userInfo: nil))
            return
        }
        firestoreService.fetchUserProfile(uid: user.uid) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.userProfile = profile
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }

    func saveProfile(skills: [String], location: String, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser,
              var profile = userProfile else {
            completion(NSError(domain: "AuthError", code: -1, userInfo: nil))
            return
        }
        profile.skills = skills
        profile.location = location
        firestoreService.saveUserProfile(profile, completion: completion)
    }

    func logout(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
