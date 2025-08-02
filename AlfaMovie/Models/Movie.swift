//
//  Movie.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import Foundation

struct Movie: Codable, Identifiable  {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let adult: Bool
    let originalLanguage: String
    let originalTitle: String
    let popularity: Double
    let video: Bool
    let budget: Int?
    let revenue: Int?
    let runtime: Int?
    let tagline: String?
    let status: String?
    let homepage: String?
    let imdbId: String?
    
    let genreIds: [Int]?
    let genres: [Genre]?
    let belongsToCollection: CollectionInfo?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let spokenLanguages: [SpokenLanguage]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, adult, popularity, video, budget, revenue, runtime, tagline, status, homepage
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case imdbId = "imdb_id"
        case genreIds = "genre_ids"
        case genres
        case belongsToCollection = "belongs_to_collection"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case spokenLanguages = "spoken_languages"
    }
    
    var posterURL: String? {
        guard let posterPath = posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }

    var backdropURL: String? {
        guard let backdropPath = backdropPath else { return nil }
        return "https://image.tmdb.org/t/p/original\(backdropPath)"
    }

    var formattedReleaseDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: releaseDate) else {
            return releaseDate
        }
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }

    var formattedRating: String {
        return String(format: "%.1f", voteAverage)
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct CollectionInfo: Codable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

struct ProductionCountry: Codable {
    let iso3166_1: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

struct SpokenLanguage: Codable {
    let englishName: String
    let iso639_1: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}


struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
} 
