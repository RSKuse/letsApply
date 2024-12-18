//
//  UserProfile.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/09.
//

import Foundation

struct UserProfile {
    let uid: String
    var name: String
    var email: String
    var location: String
    var profilePictureUrl: String? // Optional
    var jobTitle: String
    var skills: [String]
    var qualifications: [String]
    var experience: String
    var education: String

    enum CodingKeys: String, CodingKey {
        case uid, name, email, location, profilePictureUrl, jobTitle, skills, qualifications, experience, education
    }
}
