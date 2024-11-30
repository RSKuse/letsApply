//
//  FirestoreService.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/09.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    
    func saveUserProfile(_ profile: UserProfile, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            UserProfile.CodingKeys.uid.rawValue: profile.uid,
            UserProfile.CodingKeys.name.rawValue: profile.name,
            UserProfile.CodingKeys.email.rawValue: profile.email,
            UserProfile.CodingKeys.skills.rawValue: profile.skills,
            UserProfile.CodingKeys.location.rawValue: profile.location]

        // Post // Put
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
    
    func fetchJobs(completion: @escaping ([Job]) -> Void) {
        Firestore.firestore().collection(FirebaseCollections.jobs.rawValue).getDocuments { snapshot, error in
            // Check for errors and ensure there are documents
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching jobs: \(error?.localizedDescription ?? "Unknown error")")
                completion([]) // Return an empty array on error
                return
            }

            var jobs: [Job] = [] // Array to store Job objects
            print(documents.count)

            // Iterate through the documents using a for-loop
            for document in documents {
                let data = document.data() // Extract the data dictionary
                let job = Job(
                    id: document.documentID,
                    title: data[Job.CodingKeys.title.rawValue] as? String ?? "",
                    companyName: data[Job.CodingKeys.companyName.rawValue] as? String ?? "",
                    location:  data[Job.CodingKeys.location.rawValue] as? String ?? "",
                    jobType: data[Job.CodingKeys.jobType.rawValue] as? String ?? "",
                    requiredSkills: data[Job.CodingKeys.requiredSkills.rawValue] as? [String] ?? [],
                    description: data[Job.CodingKeys.description.rawValue] as? String ?? ""
                )
                jobs.append(job)
            }

            // Call the completion handler with the jobs array
            print("Jobs Fetched: \(jobs.count)")
            completion(jobs)
        }
    }
}
