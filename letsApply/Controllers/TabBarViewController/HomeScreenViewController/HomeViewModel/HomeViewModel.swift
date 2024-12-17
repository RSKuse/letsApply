//
//  HomeViewModel.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/16.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit
import FirebaseAuth

class HomeViewModel {
    
    // MARK: - Properties
    
    private let firestoreService = FirestoreService()
    private let storage = Storage.storage()
    
    // Categories to display on Home Screen
    let categories: [JobCategory] = [
        JobCategory(title: "Applied Jobs", icon: "doc.text.fill"),
        JobCategory(title: "Saved Jobs", icon: "bookmark.fill"),
        JobCategory(title: "Recommended", icon: "star.fill"),
        JobCategory(title: "Nearby Jobs", icon: "location.fill")
    ]
    
    // MARK: - Fetch User Profile
    
    func fetchUserProfile(completion: @escaping (UserProfile) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        firestoreService.fetchUserProfile(uid: uid) { result in
            switch result {
            case .success(let profile):
                completion(profile)
            case .failure(let error):
                print("Error fetching user profile: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Fetch Profile Image
    
    func loadProfileImage(urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString else {
            completion(UIImage(systemName: "person.crop.circle"))
            return
        }
        
        ProfilePictureService.shared.fetchProfilePicture(urlString: urlString) { image in
            if let image = image {
                completion(image)
            } else {
                completion(UIImage(systemName: "person.crop.circle"))
            }
        }
    }
}

// MARK: - JobCategory Model

struct JobCategory {
    let title: String
    let icon: String
}
