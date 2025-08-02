//
//  SearchViewModel.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import Foundation
import SwiftUI
import RxSwift
import RxCocoa

class SearchViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    private let tmdbService = TMDBService.shared
    
    // MARK: - RxSwift Observables
    let searchResultsRelay = BehaviorRelay<[Movie]>(value: [])
    let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    let errorMessageRelay = BehaviorRelay<String?>(value: nil)
    let searchQueryRelay = BehaviorRelay<String>(value: "")
    
    // MARK: - SwiftUI Published Properties
    @Published var searchResults: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchQuery: String = ""
    
    // MARK: - Popular Movies
    @Published var popularMovies: [Movie] = []
    @Published var popularMoviesError: String?
    
    // MARK: - Trending Movies
    @Published var trendingMovies: [Movie] = []
    @Published var trendingMoviesError: String?
    
    init() {
        setupRxBindings()
        setupSearchDebouncing()
        loadTrendingMovies()
        loadPopularMovies()
    }
    
    private func setupRxBindings() {
        // Bind RxSwift observables to SwiftUI published properties
        searchResultsRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                self?.searchResults = movies
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
        
        searchQueryRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                self?.searchQuery = query
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSearchDebouncing() {
        // Setup debounced search
        searchQueryRelay
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .flatMap { [weak self] query -> Observable<[Movie]> in
                guard let self = self else { return Observable.just([]) }
                
                self.isLoadingRelay.accept(true)
                self.errorMessageRelay.accept(nil)
                
                return self.tmdbService.searchMovies(query: query)
                    .catch { error in
                        self.errorMessageRelay.accept(error.localizedDescription)
                        self.isLoadingRelay.accept(false)
                        return Observable.just([])
                    }
            }
            .subscribe(onNext: { [weak self] movies in
                self?.searchResultsRelay.accept(movies)
                self?.isLoadingRelay.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func searchMovies(query: String) {
        // Update the search query relay which triggers the debounced search
        searchQueryRelay.accept(query)
        
        // Only clear results if query is completely empty
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            searchResultsRelay.accept([])
            errorMessageRelay.accept(nil)
        }
    }
    
    func loadTrendingMovies() {
        trendingMoviesError = nil
        tmdbService.fetchTrendingMovies()
            .subscribe(onNext: { [weak self] movies in
                self?.trendingMovies = Array(movies.prefix(6))
            }, onError: { [weak self] error in
                print("Error loading trending movies: \(error.localizedDescription)")
                self?.trendingMoviesError = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func loadPopularMovies() {
        popularMoviesError = nil
        tmdbService.fetchMoviesByPage(page: 1)
            .subscribe(onNext: { [weak self] movies in
                self?.popularMovies = Array(movies.prefix(8))
            }, onError: { [weak self] error in
                print("Error loading popular movies: \(error.localizedDescription)")
                self?.popularMoviesError = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func clearSearch() {
        searchQueryRelay.accept("")
        searchResultsRelay.accept([])
        errorMessageRelay.accept(nil)
    }
    
    // MARK: - RxSwift Computed Properties
    var searchResultsObservable: Observable<[Movie]> {
        return searchResultsRelay.asObservable()
    }
    
    var isLoadingObservable: Observable<Bool> {
        return isLoadingRelay.asObservable()
    }
    
    var errorMessageObservable: Observable<String?> {
        return errorMessageRelay.asObservable()
    }
} 