//
//  SignUpViewModel.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/11.
//

import Foundation
import FirebaseAuth

class SignUpViewModel {
    private let firebaseAuthService: FirebaseAuthenticationService
    private let firestoreService: FirestoreService

    init(firebaseAuthService: FirebaseAuthenticationService = .shared,
         firestoreService: FirestoreService = FirestoreService()) {
        self.firebaseAuthService = firebaseAuthService
        self.firestoreService = firestoreService
    }

    func createUser(
        name: String,
        email: String,
        password: String,
        location: String,
        jobTitle: String,
        skills: String,
        qualifications: String,
        experience: String,
        education: String,
        completion: @escaping (Error?) -> Void
    ) {
        firebaseAuthService.signUp(email: email, password: password) { [weak self] error in
            if let error = error {
                completion(error)
                return
            }

            guard let uid = Auth.auth().currentUser?.uid else {
                completion(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found after sign-up."]))
                return
            }

            let skillsArray = skills.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            let qualificationsArray = qualifications.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

            let profile = UserProfile(
                uid: uid,
                name: name,
                email: email,
                location: location,
                profilePictureUrl: nil,
                jobTitle: jobTitle,
                skills: skillsArray,
                qualifications: qualificationsArray,
                experience: experience,
                education: education
            )

            self?.firestoreService.saveUserProfile(profile, completion: completion)
        }
    }
    
    func updateProfilePictureUrl(_ url: String, for uid: String, completion: @escaping (Error?) -> Void) {
        // Fetch the existing user profile
        firestoreService.fetchUserProfile(uid: uid) { [weak self] result in
            switch result {
            case .success(var profile):
                // Update the profile picture URL
                profile.profilePictureUrl = url
                
                // Save the updated profile
                self?.firestoreService.saveUserProfile(profile, completion: completion)
                
            case .failure(let error):
                completion(error)
            }
        }
    }
}
