//
//  Job.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//

import Foundation

struct Job: Codable {
    let id: String
    let title: String
    let companyName: String
    let location: String
    let jobType: String
    let requiredSkills: [String]
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case companyName
        case location
        case jobType
        case requiredSkills
        case description
    }
}

