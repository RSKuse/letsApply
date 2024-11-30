//
//  Job.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//

import Foundation
import FirebaseFirestoreSwift

struct Job: Codable {
    @DocumentID var uid: String? // Maps to Firestore's document ID
    let title: String
    let companyName: String
    let location: String
    let jobType: String
    let requiredSkills: [String]
    let description: String
    
    // CodingKeys can be omitted if field names match exactly
}

