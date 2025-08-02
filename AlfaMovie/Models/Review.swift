//
//  Review.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import Foundation

struct ReviewsResponse: Codable {
    let page: Int
    let results: [Review]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
} 


struct Review: Codable, Identifiable {
    let id: String
    let author: String
    let authorDetails: AuthorDetails
    let content: String
    let createdAt: String
    let updatedAt: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case id, author, content, url
        case authorDetails = "author_details"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct AuthorDetails: Codable {
    let name: String
    let username: String
    let avatarPath: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case name, username, rating
        case avatarPath = "avatar_path"
    }

    var avatarURL: URL? {
        guard let path = avatarPath else { return nil }
        if path.starts(with: "/https") || path.starts(with: "https") {
            return URL(string: String(path.dropFirst()))
        } else {
            return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
        }
    }
}