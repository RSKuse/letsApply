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
    var allJobs: [Job] = []           // All fetched jobs
    var tailoredJobs: [Job] = []      // Filtered or tailored jobs for UI
    
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
            self?.allJobs = allJobs
            self?.tailoredJobs = allJobs.filter { job in
                job.qualifications.contains(where: profile.skills.contains)
            }
            self?.onDataUpdated?()
        }
    }
    
    func searchJobs(query: String) {
        guard !query.isEmpty else {
            tailoredJobs = allJobs
            onDataUpdated?()
            return
        }
        
        // Filter jobs based on title or company name
        tailoredJobs = allJobs.filter { job in
            job.title.lowercased().contains(query.lowercased()) ||
            job.companyName.lowercased().contains(query.lowercased())
        }
        onDataUpdated?()
    }
}
