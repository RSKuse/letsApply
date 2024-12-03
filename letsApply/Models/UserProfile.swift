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
    var skills: [String]
    var location: String
    var profilePictureUrl: String? // New field for profile picture URL
    
    enum CodingKeys: String, CodingKey {
        case uid, name, email, skills, location, profilePictureUrl
    }
}
