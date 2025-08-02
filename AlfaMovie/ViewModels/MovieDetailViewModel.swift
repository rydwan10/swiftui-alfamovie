//
//  MovieDetailViewModel.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import Foundation
import SwiftUI
import RxSwift
import RxCocoa

class MovieDetailViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    private let tmdbService = TMDBService.shared
    private let movieId: Int
    
    // MARK: - RxSwift Observables
    let movieRelay = BehaviorRelay<Movie?>(value: nil)
    let castRelay = BehaviorRelay<[CastMember]>(value: [])
    let reviewsRelay = BehaviorRelay<[Review]>(value: [])
    let relatedMoviesRelay = BehaviorRelay<[Movie]>(value: [])
    let trailersRelay = BehaviorRelay<[Trailer]>(value: [])
    let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    let errorMessageRelay = BehaviorRelay<String?>(value: nil)
    
    // MARK: - SwiftUI Published Properties
    @Published var movie: Movie?
    @Published var cast: [CastMember] = []
    @Published var reviews: [Review] = []
    @Published var relatedMovies: [Movie] = []
    @Published var trailers: [Trailer] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - UI State
    @Published var isInWatchlist: Bool = false
    @Published var isLiked: Bool = false
    @Published var selectedTab: String = "Overview"
    @Published var isLoadingReviews: Bool = false
    @Published var isLoadingCast: Bool = false
    
    let tabs = ["Overview", "Cast", "Reviews", "Related"]
    
    init(movieId: Int) {
        self.movieId = movieId
        setupRxBindings()
        loadMovieDetails(movieId: movieId)
    }
    
    private func setupRxBindings() {
        // Bind RxSwift observables to SwiftUI published properties
        movieRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movie in
                self?.movie = movie
            })
            .disposed(by: disposeBag)
        
        castRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] cast in
                self?.cast = cast
            })
            .disposed(by: disposeBag)
        
        reviewsRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] reviews in
                self?.reviews = reviews
            })
            .disposed(by: disposeBag)
        
        relatedMoviesRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                self?.relatedMovies = movies
            })
            .disposed(by: disposeBag)
        
        trailersRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] trailers in
                self?.trailers = trailers
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
    }
    
    func loadMovieDetails(movieId: Int) {
        print("🎬 Loading movie details for ID: \(movieId)")
        isLoadingRelay.accept(true)
        errorMessageRelay.accept(nil)
        
        // Load movie details
        tmdbService.fetchMovieDetails(id: movieId)
            .subscribe(onNext: { [weak self] movie in
                print("✅ Movie loaded: \(movie.title)")
                self?.movieRelay.accept(movie)
                self?.loadMovieCast(movieId: movieId)
                self?.loadRelatedMovies(movieId: movieId)
                self?.loadMovieTrailers(movieId: movieId)
                self?.loadReviews(movieId: movieId)
                self?.isLoadingRelay.accept(false)
            }, onError: { [weak self] error in
                print("❌ Error loading movie: \(error.localizedDescription)")
                self?.errorMessageRelay.accept(error.localizedDescription)
                self?.isLoadingRelay.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadMovieCast(movieId: Int) {
        isLoadingCast = true
        tmdbService.fetchMovieCast(id: movieId)
            .subscribe(onNext: { [weak self] cast in
                self?.castRelay.accept(cast)
                self?.isLoadingCast = false
            }, onError: { [weak self] error in
                print("Error loading cast: \(error.localizedDescription)")
                self?.isLoadingCast = false
            })
            .disposed(by: disposeBag)
    }
    
    private func loadRelatedMovies(movieId: Int) {
        tmdbService.fetchRelatedMovies(id: movieId)
            .subscribe(onNext: { [weak self] movies in
                self?.relatedMoviesRelay.accept(Array(movies.prefix(6)))
            }, onError: { [weak self] error in
                print("Error loading related movies: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadReviews(movieId: Int) {
        isLoadingReviews = true
        tmdbService.fetchMovieReviews(id: movieId)
            .subscribe(onNext: { [weak self] reviews in
                self?.reviewsRelay.accept(reviews)
                self?.isLoadingReviews = false
                print("Reviews loaded: \(reviews.count)")
            }, onError: { [weak self] error in
                print("Error loading reviews: \(error)")
                self?.reviewsRelay.accept([])
                self?.isLoadingReviews = false
            })
            .disposed(by: disposeBag)
    }
    
    private func loadMovieTrailers(movieId: Int) {
        tmdbService.fetchMovieTrailers(id: movieId)
            .subscribe(onNext: { [weak self] trailers in
                self?.trailersRelay.accept(trailers)
            }, onError: { [weak self] error in
                print("Error loading trailers: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Actions
    func toggleWatchlist() {
        isInWatchlist.toggle()
    }
    
    func toggleLike() {
        isLiked.toggle()
    }
    
    func selectTab(_ tab: String) {
        selectedTab = tab
        
        // // Load reviews when Reviews tab is selected
        // if tab == "Reviews" && reviews.isEmpty && !isLoadingReviews {
        //     loadReviews(movieId: movieId)
        // }
    }
    

} 