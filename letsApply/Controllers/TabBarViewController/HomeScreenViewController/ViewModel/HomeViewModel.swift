//
//  DashboardViewModel.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//


import Foundation
import FirebaseAuth

class HomeViewModel {
    
    private lazy var firestoreService = FirestoreService()
    private lazy var firebaseAuthService = FirebaseAuthenticationService()
    
    var jobs: [Job] = []
    var numberOfJobsToFetch: Int?
        
    func authenticateAndFetchJobs(completion: @escaping () -> Void) {
        if firebaseAuthService.isAuthenticatedViaEmail {
            self.fetchJobs {
                completion()
            }
        } else if firebaseAuthService.isAuthenticatedAnonymously {
            self.numberOfJobsToFetch = 2
            self.fetchJobs {
                completion()
            }
        } else {
            self.signUpAnonymously { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print("Anonymous sign-up failed: \(error.localizedDescription)")
                    completion()
                    return
                }
                self.numberOfJobsToFetch = 1
                self.fetchJobs {
                    completion()
                }
            }
        }
    }
        
    func fetchJobs(completion: @escaping () -> Void) {
        firestoreService.fetchJobs(numberOfJobsToFetch: numberOfJobsToFetch) { [weak self] fetchedJobs in
            print("Jobs fetched in ViewModel: \(fetchedJobs.count)")
            self?.jobs = fetchedJobs
            completion()
        }
    }
        
    func signUpAnonymously(completion: @escaping (Error?) -> Void) {
        firebaseAuthService.signUpAnonymously { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                completion(error)
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else {
                completion(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found after sign-up."]))
                return
            }

            // Create user profile
            let profile = UserProfile(uid: uid, name: "", email: "", skills: [], location: "")

            // Save the user profile using FirestoreService
            self.firestoreService.saveUserProfile(profile) { saveError in
                if let saveError = saveError {
                    completion(saveError)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
