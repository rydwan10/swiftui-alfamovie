//
//  TMDBService.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import Foundation
import RxSwift
import RxCocoa

class TMDBService {
    static let shared = TMDBService()
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "<YOUR API KEY>" // Replace with your actual API key
    
    private init() {}
    
    // MARK: - Movie Endpoints
    func fetchTrendingMovies() -> Observable<[Movie]> {
        let urlString = "\(baseURL)/trending/movie/week?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(NetworkError.invalidURL)
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data in
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                return response.results
            }
            .observe(on: MainScheduler.instance)
    }
    
    func fetchMovieDetails(id: Int) -> Observable<Movie> {
        let urlString = "\(baseURL)/movie/\(id)?api_key=\(apiKey)"
        print("🌐 Fetching movie details from: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            return Observable.error(NetworkError.invalidURL)
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data in
                print("📦 Received data: \(data.count) bytes")
                let decoder = JSONDecoder()
                let movie = try decoder.decode(Movie.self, from: data)
                print("✅ Decoded movie: \(movie.title)")
                return movie
            }
            .observe(on: MainScheduler.instance)
    }
    
    func fetchMovieCast(id: Int) -> Observable<[CastMember]> {
        let urlString = "\(baseURL)/movie/\(id)/credits?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(NetworkError.invalidURL)
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data in
                let decoder = JSONDecoder()
                let response = try decoder.decode(CreditsResponse.self, from: data)
                return response.cast
            }
            .observe(on: MainScheduler.instance)
    }
    
    func fetchRelatedMovies(id: Int) -> Observable<[Movie]> {
        let urlString = "\(baseURL)/movie/\(id)/similar?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(NetworkError.invalidURL)
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data in
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                return response.results
            }
            .observe(on: MainScheduler.instance)
    }
    
               func fetchMovieReviews(id: Int) -> Observable<[Review]> {
               let urlString = "\(baseURL)/movie/\(id)/reviews?api_key=\(apiKey)"
               
               guard let url = URL(string: urlString) else {
                   return Observable.error(NetworkError.invalidURL)
               }
               
               return URLSession.shared.rx.data(request: URLRequest(url: url))
                   .map { data in
                       let decoder = JSONDecoder()
                       let response = try decoder.decode(ReviewsResponse.self, from: data)
                       return response.results
                   }
                   .observe(on: MainScheduler.instance)
           }
           
           func searchMovies(query: String) -> Observable<[Movie]> {
               let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
               let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedQuery)"
               
               guard let url = URL(string: urlString) else {
                   return Observable.error(NetworkError.invalidURL)
               }
               
               return URLSession.shared.rx.data(request: URLRequest(url: url))
                   .map { data in
                       let decoder = JSONDecoder()
                       let response = try decoder.decode(MovieResponse.self, from: data)
                       return response.results
                   }
                   .observe(on: MainScheduler.instance)
           }
           
           func fetchMoviesByPage(page: Int) -> Observable<[Movie]> {
               let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&page=\(page)"
               
               guard let url = URL(string: urlString) else {
                   return Observable.error(NetworkError.invalidURL)
               }
               
               return URLSession.shared.rx.data(request: URLRequest(url: url))
                   .map { data in
                       let decoder = JSONDecoder()
                       let response = try decoder.decode(MovieResponse.self, from: data)
                       return response.results
                   }
                   .observe(on: MainScheduler.instance)
           }
           
           func fetchNowPlayingMovies() -> Observable<[Movie]> {
               let urlString = "\(baseURL)/movie/now_playing?api_key=\(apiKey)"
               
               guard let url = URL(string: urlString) else {
                   return Observable.error(NetworkError.invalidURL)
               }
               
               return URLSession.shared.rx.data(request: URLRequest(url: url))
                   .map { data in
                       let decoder = JSONDecoder()
                       let response = try decoder.decode(MovieResponse.self, from: data)
                       return response.results
                   }
                   .observe(on: MainScheduler.instance)
           }
           
           func fetchGenres() -> Observable<[GenreData]> {
               let urlString = "\(baseURL)/genre/movie/list?api_key=\(apiKey)"
               print("🌐 Starting genre API call to: \(urlString)")
               
               guard let url = URL(string: urlString) else {
                   print("❌ Invalid URL for genres")
                   return Observable.error(NetworkError.invalidURL)
               }
               
               return URLSession.shared.rx.data(request: URLRequest(url: url))
                   .map { data in
                       print("📦 Received genre data: \(data.count) bytes")
                       let decoder = JSONDecoder()
                       let response = try decoder.decode(GenreResponse.self, from: data)
                       print("✅ Decoded \(response.genres.count) genres")
                       return response.genres
                   }
                   .observe(on: MainScheduler.instance)
           }
           
           func fetchMovieTrailers(id: Int) -> Observable<[Trailer]> {
               let urlString = "\(baseURL)/movie/\(id)/videos?api_key=\(apiKey)"
               
               guard let url = URL(string: urlString) else {
                   return Observable.error(NetworkError.invalidURL)
               }
               
               return URLSession.shared.rx.data(request: URLRequest(url: url))
                   .map { data in
                       let decoder = JSONDecoder()
                       let response = try decoder.decode(TrailerResponse.self, from: data)
                       return response.results
                   }
                   .observe(on: MainScheduler.instance)
           }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .serverError(let message):
            return message
        }
    }
} 
