//
//  JobListingsViewModel.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//

import Foundation

class JobListingsViewModel {

    private let firestoreService = FirestoreService()

    var jobs: [Job] = []

    func fetchJobs(completion: @escaping () -> Void) {
        firestoreService.fetchJobs { [weak self] fetchedJobs in
            self?.jobs = fetchedJobs
            completion()
        }
    }

    func applyFilters(filters: JobFilters, completion: @escaping () -> Void) {
        firestoreService.fetchJobs { [weak self] fetchedJobs in
            self?.jobs = fetchedJobs.filter { job in
                return (filters.skills.isEmpty || filters.skills.contains(where: { job.requiredSkills.contains($0) })) &&
                       (filters.location.isEmpty || job.location.contains(filters.location)) &&
                       (filters.jobType.isEmpty || job.jobType == filters.jobType)
            }
            completion()
        }
    }
}
