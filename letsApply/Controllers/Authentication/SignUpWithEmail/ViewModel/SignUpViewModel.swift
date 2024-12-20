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

    func createUser(name: String,
                    email: String,
                    password: String,
                    location: String,
                    jobTitle: String,
                    skills: String,
                    qualifications: String,
                    experience: String,
                    education: String,
                    completion: @escaping (Error?) -> Void) {
            
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty, !location.isEmpty,
              !jobTitle.isEmpty, !skills.isEmpty, !qualifications.isEmpty,
              !experience.isEmpty, !education.isEmpty else {
            completion(NSError(domain: "ValidationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "All fields are required."]))
            return
        }

        firebaseAuthService.signUp(email: email, password: password) { [weak self] error in
            guard let self else { return }
            
            if let error = error {
                return completion(error)
            }

            guard let uid = Auth.auth().currentUser?.uid else {
                return completion(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found after sign-up."]))
            }
            
            let profile = UserProfile(uid: uid,
                                      name: name,
                                      email: email,
                                      location: location,
                                      profilePictureUrl: nil,
                                      jobTitle: jobTitle,
                                      skills: [skills],
                                      qualifications: [qualifications],
                                      experience: experience,
                                      education: education)

            self.firestoreService.saveUserProfile(profile, completion: completion)
        }
    }
    
    func updateProfilePictureUrl(_ url: String,
                                 for uid: String, completion: @escaping (Error?) -> Void) {
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
