//
//  MoviesByCategoryViewModel.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import Foundation
import SwiftUI
import RxSwift
import RxCocoa

class MoviesByCategoryViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    private let tmdbService = TMDBService.shared
    
    // MARK: - RxSwift Observables
    let moviesRelay = BehaviorRelay<[Movie]>(value: [])
    let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    let isLoadingMoreRelay = BehaviorRelay<Bool>(value: false)
    let errorMessageRelay = BehaviorRelay<String?>(value: nil)
    
    // MARK: - SwiftUI Published Properties
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Pagination
    private var currentPage = 1
    private var hasMorePages = true
    private var currentCategoryId: Int?
    
    init() {
        setupRxBindings()
    }
    
    private func setupRxBindings() {
        // Bind RxSwift observables to SwiftUI published properties
        moviesRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                self?.movies = movies
            })
            .disposed(by: disposeBag)
        
        isLoadingRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                self?.isLoading = loading
            })
            .disposed(by: disposeBag)
        
        isLoadingMoreRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                self?.isLoadingMore = loading
            })
            .disposed(by: disposeBag)
        
        errorMessageRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.errorMessage = error
            })
            .disposed(by: disposeBag)
    }
    
    func loadMovies(categoryId: Int?) {
        guard let categoryId = categoryId else {
            // If no category ID, load popular movies
            loadPopularMovies()
            return
        }
        
        currentCategoryId = categoryId
        currentPage = 1
        hasMorePages = true
        
        isLoadingRelay.accept(true)
        errorMessageRelay.accept(nil)
        
        tmdbService.fetchMoviesByPage(page: currentPage)
            .subscribe(onNext: { [weak self] movies in
                // Filter movies by category
                let filteredMovies = movies.filter { movie in
                    movie.genreIds?.contains(categoryId) == true
                }
                
                self?.moviesRelay.accept(filteredMovies)
                self?.isLoadingRelay.accept(false)
                self?.hasMorePages = movies.count >= 20 // TMDB typically returns 20 movies per page
            }, onError: { [weak self] error in
                print("Error loading movies by category: \(error.localizedDescription)")
                self?.errorMessageRelay.accept(error.localizedDescription)
                self?.isLoadingRelay.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadPopularMovies() {
        currentPage = 1
        hasMorePages = true
        
        isLoadingRelay.accept(true)
        errorMessageRelay.accept(nil)
        
        tmdbService.fetchMoviesByPage(page: currentPage)
            .subscribe(onNext: { [weak self] movies in
                self?.moviesRelay.accept(movies)
                self?.isLoadingRelay.accept(false)
                self?.hasMorePages = movies.count >= 20
            }, onError: { [weak self] error in
                print("Error loading popular movies: \(error.localizedDescription)")
                self?.errorMessageRelay.accept(error.localizedDescription)
                self?.isLoadingRelay.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func loadMoreMovies() {
        guard hasMorePages && !isLoadingMore else { return }
        
        currentPage += 1
        isLoadingMoreRelay.accept(true)
        
        tmdbService.fetchMoviesByPage(page: currentPage)
            .subscribe(onNext: { [weak self] newMovies in
                guard let self = self else { return }
                
                var allMovies = self.movies
                
                if let categoryId = self.currentCategoryId {
                    // Filter movies by category
                    let filteredMovies = newMovies.filter { movie in
                        movie.genreIds?.contains(categoryId) == true
                    }
                    allMovies.append(contentsOf: filteredMovies)
                } else {
                    // Add all movies for popular movies
                    allMovies.append(contentsOf: newMovies)
                }
                
                self.moviesRelay.accept(allMovies)
                self.isLoadingMoreRelay.accept(false)
                self.hasMorePages = newMovies.count >= 20
            }, onError: { [weak self] error in
                print("Error loading more movies: \(error.localizedDescription)")
                self?.isLoadingMoreRelay.accept(false)
                self?.hasMorePages = false
            })
            .disposed(by: disposeBag)
    }
    
    func refreshMovies() {
        if let categoryId = currentCategoryId {
            loadMovies(categoryId: categoryId)
        } else {
            loadPopularMovies()
        }
    }
} 