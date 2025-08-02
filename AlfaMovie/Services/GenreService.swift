//
//  GenreService.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import Foundation
import SwiftData
import RxSwift

class GenreService {
    static let shared = GenreService()
    private let tmdbService = TMDBService.shared
    private let disposeBag = DisposeBag()
    
    private init() {}
    
    // MARK: - Cache Duration (24 hours)
    private let cacheDuration: TimeInterval = 24 * 60 * 60
    
    // MARK: - Get Genre Name by ID
    func getGenreName(for id: Int) -> String {
        if let cachedGenres = getCachedGenres() {
            return cachedGenres.first { $0.id == id }?.name ?? "Action"
        }
        return "Action"
    }
    
    // MARK: - Get Genre Names for Multiple IDs
    func getGenreNames(for ids: [Int]) -> String? {
        if let cachedGenres = getCachedGenres() {
            let genreNames = ids.compactMap { id in
                cachedGenres.first { $0.id == id }?.name
            }
            return genreNames.isEmpty ? nil : genreNames.joined(separator: ", ")
        }
        return nil
    }
    
    // MARK: - Load Genres to Cache
    func loadGenresToCache() {
        print("Starting genre API call...")
        tmdbService.fetchGenres()
            .subscribe(onNext: { [weak self] genres in
                print("Genres loaded successfully: \(genres.count) genres")
                self?.cacheGenres(genres)
            }, onError: { error in
                print("Error loading genres: \(error)")
            }, onCompleted: {
                print("Genre API call completed")
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize Cache (for previews)
    func initializeCache() {
        // This method can be called to ensure cache is available for previews
        if getCachedGenres() == nil {
            loadGenresToCache()
        }
    }
    
    // MARK: - Private Methods
    private func getCachedGenres() -> [GenreData]? {
        do {
            let modelContainer = try ModelContainer(for: CachedGenre.self)
            let modelContext = ModelContext(modelContainer)
            
            let descriptor = FetchDescriptor<CachedGenre>()
            let cachedGenres = try modelContext.fetch(descriptor)
            
            // Check if cache is still valid
            guard !cachedGenres.isEmpty else {
                return nil
            }
            
            let oldestGenre = cachedGenres.min { $0.lastUpdated < $1.lastUpdated }
            guard let oldest = oldestGenre else { return nil }
            
            // Check if cache has expired
            if Date().timeIntervalSince(oldest.lastUpdated) > cacheDuration {
                // Clear expired cache
                try modelContext.delete(model: CachedGenre.self)
                try modelContext.save()
                return nil
            }
            
            // Convert to GenreData
            return cachedGenres.map { GenreData(id: $0.id, name: $0.name) }
        } catch {
            print("Error accessing cached genres: \(error)")
            return nil
        }
    }
    
    private func cacheGenres(_ genres: [GenreData]) {
        do {
            let modelContainer = try ModelContainer(for: CachedGenre.self)
            let modelContext = ModelContext(modelContainer)
            
            // Clear existing cache
            try modelContext.delete(model: CachedGenre.self)
            
            // Add new genres to cache
            for genreData in genres {
                let genre = CachedGenre(id: genreData.id, name: genreData.name)
                modelContext.insert(genre)
            }
            
            // Save to persistent storage
            try modelContext.save()
        } catch {
            print("Error caching genres: \(error)")
        }
    }
} 