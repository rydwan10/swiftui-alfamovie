//
//  Trailer.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import Foundation

struct Trailer: Codable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case key
        case name
        case site
        case size
        case type
        case official
        case publishedAt = "published_at"
    }
    
    var youtubeURL: URL? {
        guard site.lowercased() == "youtube" else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
    
    var thumbnailURL: URL? {
        guard site.lowercased() == "youtube" else { return nil }
        return URL(string: "https://img.youtube.com/vi/\(key)/maxresdefault.jpg")
    }
}

struct TrailerResponse: Codable {
    let id: Int
    let results: [Trailer]
} 