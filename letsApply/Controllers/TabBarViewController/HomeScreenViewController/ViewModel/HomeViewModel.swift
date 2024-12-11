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
    var filteredJobs: [Job] = []
    var numberOfJobsToFetch: Int?
    var currentFilters: JobFilters?
    
        
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
            self?.filteredJobs = fetchedJobs
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
    
    func filterJobs(with query: String) {
        if let currentFilters = currentFilters {
            filteredJobs = jobs.filter { job in
                let matchesSearch = job.title.lowercased().contains(query.lowercased()) ||
                                    job.companyName.lowercased().contains(query.lowercased())
                var matchesFilters = true
                if !currentFilters.skills.isEmpty {
                    let jobSkills = job.requirements.map { $0.lowercased() }
                    let filterSkills = currentFilters.skills.map { $0.lowercased() }
                    matchesFilters = matchesFilters && filterSkills.allSatisfy { jobSkills.contains($0) }
                }
                if !currentFilters.location.isEmpty {
                    matchesFilters = matchesFilters && job.location.city.lowercased().contains(currentFilters.location.lowercased())
                }
                if !currentFilters.jobType.isEmpty {
                    matchesFilters = matchesFilters && job.jobType.lowercased().contains(currentFilters.jobType.lowercased())
                }
                return matchesSearch && matchesFilters
            }
        } else {
            filteredJobs = jobs.filter { job in
                job.title.lowercased().contains(query.lowercased()) ||
                job.companyName.lowercased().contains(query.lowercased())
            }
        }
    }
    
    func applyFilters(_ filters: JobFilters) {
        self.currentFilters = filters
        filteredJobs = jobs.filter { job in
            let matchesSkills = filters.skills.isEmpty || filters.skills.allSatisfy { job.requirements.contains($0) }
            let matchesLocation = filters.location.isEmpty || job.location.city.lowercased().contains(filters.location.lowercased())
            let matchesJobType = filters.jobType.isEmpty || job.jobType.lowercased().contains(filters.jobType.lowercased())
            return matchesSkills && matchesLocation && matchesJobType
        }
    }
    
    func resetFilters() {
        currentFilters = nil
        filteredJobs = jobs
    }

}
    

