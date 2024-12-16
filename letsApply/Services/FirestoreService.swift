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
    
    func saveUserProfile(_ profile: UserProfile, completion: @escaping (Error?) -> Void) {
        var data: [String: Any] = [
            UserProfile.CodingKeys.uid.rawValue: profile.uid,
            UserProfile.CodingKeys.name.rawValue: profile.name,
            UserProfile.CodingKeys.email.rawValue: profile.email,
            UserProfile.CodingKeys.skills.rawValue: profile.skills,
            UserProfile.CodingKeys.location.rawValue: profile.location
        ]
        
        // Include profile picture URL if available
        if let profilePictureUrl = profile.profilePictureUrl {
            data[UserProfile.CodingKeys.profilePictureUrl.rawValue] = profilePictureUrl
        }

        Firestore.firestore()
            .collection(FirebaseCollections.users.rawValue)
            .document(profile.uid)
            .setData(data) { error in
                completion(error)
            }
    }

    func fetchUserProfile(uid: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        
        Firestore.firestore()
            .collection(FirebaseCollections.users.rawValue)
            .document(uid)
            .getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = snapshot?.data(),
                  let name = data[UserProfile.CodingKeys.name.rawValue] as? String,
                  let email = data[UserProfile.CodingKeys.email.rawValue] as? String,
                  let skills = data[UserProfile.CodingKeys.skills.rawValue] as? [String],
                  let location = data[UserProfile.CodingKeys.location.rawValue] as? String else {
                completion(.failure(NSError(domain: "DataParsing", code: -1, userInfo: nil)))
                return
            }
            let profile = UserProfile(uid: uid, name: name, email: email, skills: skills, location: location)
            completion(.success(profile))
        }
    }
    
    func fetchJobs(numberOfJobsToFetch jobCount: Int? = nil,
                   completion: @escaping ([Job]) -> Void) {
        
        let firestore =  Firestore.firestore()
        var query: Query = firestore.collection(FirebaseCollections.jobs.rawValue)
        
        // query.limit(toLast: 10)
        // query.filter(using: )
        // query.whereField("title", isEqualTo: "Clerk: Branch Administration")
        
        if let count = jobCount {
            query = query.limit(to: count)
        }
        
        query.getDocuments { [weak self] snapshot, error in
            guard let self  else { return }
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

    /// Fetches the profile picture URL from Firebase Storage.
    func fetchProfileImageURL(uid: String, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = storage.reference().child("profile_pictures/\(uid).jpg")
        storageRef.downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            } else if let url = url {
                completion(.success(url.absoluteString))
            }
        }
    }
}
    
