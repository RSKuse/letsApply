//
//  DashboardViewModel.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//


import Foundation

class HomeViewModel {
    private let firestoreService = FirestoreService()
    var jobs: [Job] = []

    func fetchJobs(completion: @escaping () -> Void) {
        firestoreService.fetchJobs { [weak self] fetchedJobs in
            print("Jobs fetched in ViewModel: \(fetchedJobs.count)")
            self?.jobs = fetchedJobs
            completion()
        }
    }
}
