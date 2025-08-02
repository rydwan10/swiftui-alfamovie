//
//  CastMember.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import Foundation

struct CreditsResponse: Codable {
    let id: Int
    let cast: [CastMember]
    let crew: [CrewMember]
}

struct CastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let originalName: String
    let character: String
    let profilePath: String?
    let creditId: String
    let castId: Int?
    let order: Int?
    let popularity: Double
    let knownForDepartment: String
    let gender: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, character, popularity, gender
        case originalName = "original_name"
        case profilePath = "profile_path"
        case creditId = "credit_id"
        case castId = "cast_id"
        case order
        case knownForDepartment = "known_for_department"
    }

    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
}

struct CrewMember: Codable, Identifiable {
    let id: Int
    let name: String
    let originalName: String
    let job: String
    let department: String
    let profilePath: String?
    let creditId: String
    let popularity: Double
    let knownForDepartment: String
    let gender: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, job, department, popularity, gender
        case originalName = "original_name"
        case profilePath = "profile_path"
        case creditId = "credit_id"
        case knownForDepartment = "known_for_department"
    }

    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
}
