//
//  Job.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//

import Foundation
import CoreLocation
import FirebaseFirestore

struct Job: Codable {
    let id: String?
    let title: String
    let companyName: String
    let location: Location
    let jobType: String
    let remote: Bool
    let description: String
    let qualifications: [String]
    let responsibilities: [String]
    let requirements: [String]
    let experience: Experience
    let compensation: Compensation
    let application: Application
    let jobCategory: String
    let postingDate: String
    let visibility: Visibility
    let promoted: [String]?
}

struct Location: Codable {
    let city: String
    let region: String
    let country: String
   let coordinates: CLLocation // Geopoint
}

struct Experience: Codable {
    let minYears: Int
    let preferredYears: Int // Changed from String to Int
    let details: String
}

struct Compensation: Codable {
    let salaryRange: SalaryRange
    let benefits: [String]
}

struct SalaryRange: Codable {
    let min: Int // Changed from String to Int
    let max: Int // Changed from String to Int
    let currency: String
}

struct Application: Codable {
    let deadline: Timestamp
    let applicationUrl: String
    let applicationEmail: String
    let contactPhone: String
}

struct Visibility: Codable {
    let featured: Bool
    let promoted: Bool
}
                
