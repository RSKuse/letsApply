//
//  DashboardViewModel.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//


import Foundation
import FirebaseAuth

class DashboardViewModel {
    
    private let firestoreService = FirestoreService()
    private let profilePictureService = ProfilePictureService.shared
    
    // Observables for View updates
    var greetingMessage: String = "Welcome, Guest!" // Default value
    var profilePictureURL: String? // Profile Picture URL
    
    /// Fetch Greeting Message
    func fetchGreeting(completion: @escaping (String) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion("Welcome, Guest!")
            return
        }
        
        firestoreService.fetchUserProfile(uid: user.uid) { result in
            switch result {
            case .success(let profile):
                completion("Welcome, \(profile.name)!")
            case .failure:
                completion("Welcome, Guest!")
            }
        }
    }
    
    /// Fetch Profile Picture URL
    
    func fetchUserProfile(completion: @escaping (UserProfile?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        firestoreService.fetchUserProfile(uid: user.uid) { result in
            switch result {
            case .success(let profile):
                completion(profile)
            case .failure:
                completion(nil)
            }
        }
    }
    
    
    func logout(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    private func updateProfileImage(completion: @escaping (UIImage?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        firestoreService.fetchProfileImageURL(uid: uid) { [weak self] result in
            switch result {
            case .success(let url):
                self?.loadImage(from: url, completion: completion)
            case .failure(let error):
                print("Failed to fetch profile image URL:", error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    /// Fetch Profile Picture from URL
    private func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        profilePictureService.fetchProfilePicture(urlString: url, completion: completion)
    }
}
    
