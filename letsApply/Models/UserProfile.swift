//
//  UserProfile.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/09.
//

struct UserProfile: Codable {
    var uid: String
    var name: String
    var email: String
    var location: String
    var profilePictureUrl: String?
    var jobTitle: String
    var skills: [String]
    var qualifications: [String]
    var experience: String
    var education: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case email
        case location
        case profilePictureUrl = "profile_picture_url"
        case jobTitle = "job_title"
        case skills
        case qualifications
        case experience
        case education
    }

//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.uid = try container.decode(String.self, forKey: .uid)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.email = try container.decode(String.self, forKey: .email)
//        self.location = try container.decodeIfPresent(String.self, forKey: .location) ?? "Unknown"
//        self.profilePictureUrl = try container.decodeIfPresent(String.self, forKey: .profilePictureUrl)
//        self.jobTitle = try container.decodeIfPresent(String.self, forKey: .jobTitle) ?? "Not Specified"
//        self.skills = try container.decodeIfPresent([String].self, forKey: .skills) ?? []
//        self.qualifications = try container.decodeIfPresent([String].self, forKey: .qualifications) ?? []
//        self.experience = try container.decodeIfPresent(String.self, forKey: .experience) ?? "None"
//        self.education = try container.decodeIfPresent(String.self, forKey: .education) ?? "None"
//    }
}
