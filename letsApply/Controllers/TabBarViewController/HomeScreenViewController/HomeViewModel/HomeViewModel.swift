//
//  HomeViewModel.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/16.
//

import Foundation
import FirebaseFirestore

class HomeViewModel {
    private let firestoreService = FirestoreService()
    var userProfile: UserProfile?
    var tailoredJobs: [Job] = []
    
    var onDataUpdated: (() -> Void)?
    
    func fetchUserProfile(uid: String) {
        firestoreService.fetchUserProfile(uid: uid) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.userProfile = profile
                self?.fetchTailoredJobs(for: profile)
            case .failure(let error):
                print("Error fetching user profile: \(error)")
            }
        }
    }
    
    private func fetchTailoredJobs(for profile: UserProfile) {
        firestoreService.fetchJobs { [weak self] allJobs in
            // Filter jobs based on user profile
            self?.tailoredJobs = allJobs.filter { job in
                job.qualifications.contains(where: profile.skills.contains)
            }
            self?.onDataUpdated?()
        }
    }
}
