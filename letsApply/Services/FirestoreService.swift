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
    
    /*
    func fetchJobs(completion: @escaping ([Job]) -> Void) {
        Firestore.firestore().collection(FirebaseCollections.jobs.rawValue).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching jobs: \(error!.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found in 'jobs' collection.")
                completion([])
                return
            }

            let jobs = documents.compactMap { doc -> Job? in
                let data = doc.data()
                print("Fetched Job Document: \(data)")
                guard let title = data[Job.CodingKeys.title.rawValue] as? String,
                      let companyName = data[Job.CodingKeys.companyName.rawValue] as? String,
                      let location = data[Job.CodingKeys.location.rawValue] as? String,
                      let jobType = data[Job.CodingKeys.jobType.rawValue] as? String,
                      let requiredSkills = data[Job.CodingKeys.requiredSkills.rawValue] as? [String],
                      let description = data[Job.CodingKeys.description.rawValue] as? String else {
                    print("Invalid job document format.")
                    return nil
                }
                return Job(id: doc.documentID, title: title, companyName: companyName, location: location, jobType: jobType, requiredSkills: requiredSkills, description: description)
            }
            completion(jobs)
        }
    }
    */
    
    func fetchJobs(completion: @escaping ([Job], Error?) -> Void) {
        Firestore
            .firestore()
            .collection(FirebaseCollections.jobs.rawValue)
            .getDocuments { (snapshot, error) in
                
                if let error = error {
                    print("Error fetching documents: \(error)")
                    completion([], error)
                    return
                }
                
                var jobs: [Job] = []
                for document in snapshot?.documents ?? [] {
                    do {
                        let job = try document.data(as: Job.self)
                        jobs.append(job)
                    } catch {
                        print("Error decoding document: \(error)")
                        completion([], error)
                        return
                    }
                }
            
                print(jobs)
                
                completion(jobs, nil)
        }
    }
}
