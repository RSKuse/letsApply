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
            "skills": profile.skills,
            "location": profile.location
        ]

        db.collection("users").document(profile.uid).setData(data) { error in
            completion(error)
        }
    }

    func fetchUserProfile(uid: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = snapshot?.data(),
                  let name = data["name"] as? String,
                  let email = data["email"] as? String,
                  let skills = data["skills"] as? [String],
                  let location = data["location"] as? String else {
                completion(.failure(NSError(domain: "DataParsing", code: -1, userInfo: nil)))
                return
            }
            let profile = UserProfile(uid: uid, name: name, email: email, skills: skills, location: location)
            completion(.success(profile))
        }
    }
}
