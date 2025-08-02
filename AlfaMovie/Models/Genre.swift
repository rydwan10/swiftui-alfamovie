//
//  Genre.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import Foundation
import SwiftData

@Model
class CachedGenre: Identifiable {
    let id: Int
    let name: String
    let lastUpdated: Date
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
        self.lastUpdated = Date()
    }
}

struct GenreResponse: Codable {
    let genres: [GenreData]
}

struct GenreData: Codable {
    let id: Int
    let name: String
} 