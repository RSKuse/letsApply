//
//  FirestoreService.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/09.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

class FirestoreService {
    
    private let storage = Storage.storage()
    
    /// Saves the user profile to Firestore
    func saveUserProfile(_ profile: UserProfile, completion: @escaping (Error?) -> Void) {
        var data: [String: Any] = [
            "uid": profile.uid,
            "name": profile.name,
            "email": profile.email,
            "location": profile.location,
            "jobTitle": profile.jobTitle,
            "skills": profile.skills,
            "qualifications": profile.qualifications,
            "experience": profile.experience,
            "education": profile.education
        ]

        if let profilePictureUrl = profile.profilePictureUrl {
            data["profilePictureUrl"] = profilePictureUrl
        }

        Firestore.firestore()
            .collection("users")
            .document(profile.uid)
            .setData(data) { error in
                completion(error)
            }
    }
    
    /// Fetches the user profile from Firestore
    func fetchUserProfile(uid: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = snapshot?.data() else {
                    completion(.failure(NSError(domain: "DataParsing", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document not found or has no data."])))
                    return
                }

                // Log the fetched data
                print("Fetched data: \(data)")

                // Validate and map data
                guard let name = data["name"] as? String,
                      let email = data["email"] as? String,
                      let location = data["location"] as? String,
                      let jobTitle = data["jobTitle"] as? String,
                      let skills = data["skills"] as? [String],
                      let qualifications = data["qualifications"] as? [String],
                      let experience = data["experience"] as? String,
                      let education = data["education"] as? String else {
                    completion(.failure(NSError(domain: "DataParsing", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing or incorrect fields."])))
                    return
                }

                let profile = UserProfile(
                    uid: uid,
                    name: name,
                    email: email,
                    location: location,
                    profilePictureUrl: data["profilePictureUrl"] as? String,
                    jobTitle: jobTitle,
                    skills: skills,
                    qualifications: qualifications,
                    experience: experience,
                    education: education
                )
                completion(.success(profile))
            }
    }
    
    /// Fetches jobs from Firestore
    func fetchJobs(numberOfJobsToFetch jobCount: Int? = nil, completion: @escaping ([Job]) -> Void) {
        let firestore = Firestore.firestore()
        var query: Query = firestore.collection(FirebaseCollections.jobs.rawValue)
        
        if let count = jobCount {
            query = query.limit(to: count)
        }
        
        query.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching jobs: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found in jobs collection")
                completion([])
                return
            }
            
            let jobs = self.extractJobs(from: documents)
            completion(jobs)
        }
    }
    
    /// Extracts job data from Firestore documents
    private func extractJobs(from documents: [QueryDocumentSnapshot]) -> [Job] {
        var jobs: [Job] = []
        for document in documents {
            let data = document.data()
            
            // Extract location
            let locationData = data["location"] as? [String: Any] ?? [:]
            let location = Location(
                city: locationData["city"] as? String ?? "",
                region: locationData["region"] as? String ?? "",
                country: locationData["country"] as? String ?? ""
            )
            
            // Extract experience
            let experienceData = data["experience"] as? [String: Any] ?? [:]
            let experience = Experience(
                minYears: experienceData["minYears"] as? Int ?? 0,
                preferredYears: experienceData["preferredYears"] as? Int ?? 0,
                details: experienceData["details"] as? String ?? ""
            )
            
            // Extract compensation
            let compensationData = data["compensation"] as? [String: Any] ?? [:]
            let salaryRangeData = compensationData["salaryRange"] as? [String: Any] ?? [:]
            let salaryRange = SalaryRange(
                min: salaryRangeData["min"] as? Int ?? 0,
                max: salaryRangeData["max"] as? Int ?? 0,
                currency: salaryRangeData["currency"] as? String ?? ""
            )
            let benefits = compensationData["benefits"] as? [String] ?? []
            let compensation = Compensation(salaryRange: salaryRange, benefits: benefits)
            
            // Extract application
            let applicationData = data["application"] as? [String: Any] ?? [:]
            let application = Application(
                deadline: applicationData["deadline"] as? String ?? "",
                applicationUrl: applicationData["applicationUrl"] as? String ?? "",
                applicationEmail: applicationData["applicationEmail"] as? String ?? "",
                contactPhone: applicationData["contactPhone"] as? String ?? ""
            )
            
            // Extract visibility
            let visibilityData = data["visibility"] as? [String: Any] ?? [:]
            let visibility = Visibility(
                featured: visibilityData["featured"] as? Bool ?? false,
                promoted: visibilityData["promoted"] as? Bool ?? false
            )
            
            // Now extract top-level fields
            let qualifications = data["qualifications"] as? [String] ?? []
            let responsibilities = data["responsibilities"] as? [String] ?? []
            let requirements = data["requirements"] as? [String] ?? []
            let promotedTags = data["promoted"] as? [String]
            
            let job = Job(
                id: document.documentID,
                title: data["title"] as? String ?? "",
                companyName: data["companyName"] as? String ?? "",
                location: location,
                jobType: data["jobType"] as? String ?? "",
                remote: data["remote"] as? Bool ?? false,
                description: data["description"] as? String ?? "",
                qualifications: qualifications,
                responsibilities: responsibilities,
                requirements: requirements,
                experience: experience,
                compensation: compensation,
                application: application,
                jobCategory: data["jobCategory"] as? String ?? "",
                postingDate: data["postingDate"] as? String ?? "",
                visibility: visibility,
                promoted: promotedTags
            )
            
            jobs.append(job)
        }
        return jobs
    }
    
    /// Uploads profile image to Firebase Storage
    func uploadProfileImage(uid: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageConversionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data."])))
            return
        }
        
        let storageRef = storage.reference().child("profile_pictures/\(uid).jpg")
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
}
