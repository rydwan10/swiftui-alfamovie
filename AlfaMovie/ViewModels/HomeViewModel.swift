//
//  HomeViewModel.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import Foundation
import SwiftUI
import RxSwift
import RxCocoa

class HomeViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    private let tmdbService = TMDBService.shared
    private let genreService = GenreService.shared
    
    // MARK: - RxSwift Observables
    let trendingMoviesRelay = BehaviorRelay<[MovieItem]>(value: [])
    let recentlyAddedMoviesRelay = BehaviorRelay<[MovieItem]>(value: [])
    let featuredMoviesRelay = BehaviorRelay<[MovieItem]>(value: [])
    let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    let isLoadingMoreRelay = BehaviorRelay<Bool>(value: false)
    let errorMessageRelay = BehaviorRelay<String?>(value: nil)
    
    // MARK: - SwiftUI Published Properties (for compatibility)
    @Published var trendingMovies: [MovieItem] = []
    @Published var recentlyAddedMovies: [MovieItem] = []
    @Published var featuredMovies: [MovieItem] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Pagination
    private var currentPage = 1
    private var hasMorePages = true
    
    init() {
        setupRxBindings()
        loadTrendingMovies()
        loadRecentlyAddedMovies()
        loadFeaturedMovies()
        
        // Load genres to cache immediately
        genreService.loadGenresToCache()
    }
    
    private func setupRxBindings() {
        // Bind RxSwift observables to SwiftUI published properties
        trendingMoviesRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                self?.trendingMovies = movies
            })
            .disposed(by: disposeBag)
        
        isLoadingRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                self?.isLoading = loading
            })
            .disposed(by: disposeBag)
        
        errorMessageRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.errorMessage = error
            })
            .disposed(by: disposeBag)
        
        recentlyAddedMoviesRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                self?.recentlyAddedMovies = movies
            })
            .disposed(by: disposeBag)
        
        isLoadingMoreRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                self?.isLoadingMore = loading
            })
            .disposed(by: disposeBag)
        
        featuredMoviesRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                self?.featuredMovies = movies
            })
            .disposed(by: disposeBag)
    }
    
    func loadTrendingMovies() {
        isLoadingRelay.accept(true)
        errorMessageRelay.accept(nil)
        
        tmdbService.fetchTrendingMovies()
            .subscribe(onNext: { [weak self] movies in
                let movieItems = movies.prefix(10).map { movie in
                    MovieItem(
                        id: movie.id,
                        title: movie.title,
                        genre: self?.genreService.getGenreNames(for: movie.genreIds ?? []) ?? "Action",
                        rating: String(format: "%.1f", movie.voteAverage),
                        imageName: "film",
                        posterURL: movie.posterURL
                    )
                }
                self?.trendingMoviesRelay.accept(Array(movieItems))
                self?.isLoadingRelay.accept(false)
            }, onError: { [weak self] error in
                self?.errorMessageRelay.accept(error.localizedDescription)
                self?.isLoadingRelay.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func refreshTrendingMovies() {
        loadTrendingMovies()
    }
    
    func loadRecentlyAddedMovies() {
        currentPage = 1
        hasMorePages = true
        isLoadingMoreRelay.accept(true)
        
        tmdbService.fetchMoviesByPage(page: currentPage)
            .subscribe(onNext: { [weak self] movies in
                let movieItems = movies.map { movie in
                    MovieItem(
                        id: movie.id,
                        title: movie.title,
                        genre: self?.genreService.getGenreNames(for: movie.genreIds ?? []) ?? "Action",
                        rating: String(format: "%.1f", movie.voteAverage),
                        imageName: "film",
                        posterURL: movie.posterURL
                    )
                }
                self?.recentlyAddedMoviesRelay.accept(movieItems)
                self?.isLoadingMoreRelay.accept(false)
            }, onError: { [weak self] error in
                self?.errorMessageRelay.accept(error.localizedDescription)
                self?.isLoadingMoreRelay.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func loadFeaturedMovies() {
        tmdbService.fetchNowPlayingMovies()
            .subscribe(onNext: { [weak self] movies in
                let movieItems = movies.prefix(5).map { movie in
                    MovieItem(
                        id: movie.id,
                        title: movie.title,
                        genre: self?.genreService.getGenreNames(for: movie.genreIds ?? []) ?? "Action",
                        rating: String(format: "%.1f", movie.voteAverage),
                        imageName: "film",
                        posterURL: movie.backdropURL // Use backdrop for featured cards
                    )
                }
                self?.featuredMoviesRelay.accept(Array(movieItems))
            }, onError: { [weak self] error in
                self?.errorMessageRelay.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadMoreRecentlyAddedMovies() {
        guard hasMorePages && !isLoadingMore else { return }
        
        currentPage += 1
        isLoadingMoreRelay.accept(true)
        
        tmdbService.fetchMoviesByPage(page: currentPage)
            .subscribe(onNext: { [weak self] movies in
                guard let self = self else { return }
                
                let movieItems = movies.map { movie in
                    MovieItem(
                        id: movie.id,
                        title: movie.title,
                        genre: self.genreService.getGenreNames(for: movie.genreIds ?? []) ?? "Action",
                        rating: String(format: "%.1f", movie.voteAverage),
                        imageName: "film",
                        posterURL: movie.posterURL
                    )
                }
                
                // Append new movies to existing ones
                let currentMovies = self.recentlyAddedMoviesRelay.value
                self.recentlyAddedMoviesRelay.accept(currentMovies + movieItems)
                self.isLoadingMoreRelay.accept(false)
                
                // Check if we've reached the end (TMDB typically has 1000 pages max)
                if currentPage >= 1000 {
                    self.hasMorePages = false
                }
            }, onError: { [weak self] error in
                self?.currentPage -= 1 // Revert page increment on error
                self?.errorMessageRelay.accept(error.localizedDescription)
                self?.isLoadingMoreRelay.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - RxSwift Computed Properties
    var trendingMoviesObservable: Observable<[MovieItem]> {
        return trendingMoviesRelay.asObservable()
    }
    
    var isLoadingObservable: Observable<Bool> {
        return isLoadingRelay.asObservable()
    }
    
    var errorMessageObservable: Observable<String?> {
        return errorMessageRelay.asObservable()
    }
}

struct MovieItem: Identifiable {
    let id: Int
    let title: String
    let genre: String
    let rating: String
    let imageName: String
    let posterURL: String?
}


