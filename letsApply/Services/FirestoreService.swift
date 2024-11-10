//
//  FirestoreService.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/09.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()

    func saveUserProfile(_ profile: UserProfile, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "uid": profile.uid,
            "name": profile.name,
            "email": profile.email,
            "skills": profile.skills
        ]

        db.collection("users").document(profile.uid).setData(data) { error in
            completion(error)
        }
    }
}
