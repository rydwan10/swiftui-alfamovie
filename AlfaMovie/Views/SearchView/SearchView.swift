//
//  SearchView.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    @State private var isNavigatingToDetail = false
    private let genreService = GenreService.shared
    
    let filters = ["All", "Movies", "TV Shows", "Documentaries"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Header
                VStack(spacing: 16) {
                    HStack {
                        Text("Search")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            // Filter action
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search movies...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .onChange(of: searchText) { newValue in
                                if !isNavigatingToDetail {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        viewModel.searchMovies(query: newValue)
                                    }
                                }
                            }
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                viewModel.clearSearch()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(12)
                    
//                    // Filter Pills
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 12) {
//                            ForEach(filters, id: \.self) { filter in
//                                FilterPill(
//                                    title: filter,
//                                    isSelected: selectedFilter == filter
//                                ) {
//                                    selectedFilter = filter
//                                }
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
                }
                .padding()
                
                
                // Search Results
                if searchText.isEmpty {
                    // Popular Searches
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Popular Searches")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            if let popularError = viewModel.popularMoviesError {
                                ErrorView(
                                    title: "Failed to load popular movies",
                                    message: popularError,
                                    buttonTitle: "Refresh",
                                    action: {
                                        viewModel.loadPopularMovies()
                                    }
                                )
                            } else {
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 16) {
                                    ForEach(viewModel.popularMovies) { movie in
                                        NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                                            MovieCard(
                                                title: movie.title,
                                                genre: genreService.getGenreNames(for: movie.genreIds ?? []) ?? "Action",
                                                rating: movie.formattedRating,
                                                imageName: "film",
                                                posterURL: movie.posterURL
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Trending Movies
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Trending Movies")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                if let trendingError = viewModel.trendingMoviesError {
                                    ErrorView(
                                        title: "Failed to load trending movies",
                                        message: trendingError,
                                        buttonTitle: "Refresh",
                                        action: {
                                            viewModel.loadTrendingMovies()
                                        }
                                    )
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(viewModel.trendingMovies) { movie in
                                                NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                                                    MovieCard(
                                                        title: movie.title,
                                                        genre: genreService.getGenreNames(for: movie.genreIds ?? []) ?? "Action",
                                                        rating: movie.formattedRating,
                                                        imageName: "film",
                                                        posterURL: movie.posterURL
                                                    )
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                } else {
                    // Search Results
                    if viewModel.isLoading {
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.5)
                            
                            Text("Searching...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.vertical, 50)
                    } else if let errorMessage = viewModel.errorMessage {
                        ErrorView(
                            title: "Failed to load data",
                            message: errorMessage,
                            buttonTitle: "Refresh",
                            action: {
                                viewModel.searchMovies(query: searchText)
                            }
                        )
                    } else if viewModel.searchResults.isEmpty && !searchText.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "magnifyingglass")
                                .font(.title)
                                .foregroundColor(.secondary)
                            
                            Text("No results found")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Text("Try searching for something else")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.vertical, 50)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(viewModel.searchResults) { movie in
                                    NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                                        MovieCard(
                                            title: movie.title,
                                            genre: genreService.getGenreNames(for: movie.genreIds ?? []) ?? "Action",
                                            rating: movie.formattedRating,
                                            imageName: "film",
                                            posterURL: movie.posterURL
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .onTapGesture {
                                        isNavigatingToDetail = true
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .onAppear {
            isNavigatingToDetail = false
        }
    }
}

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.secondary.opacity(0.1))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}



struct TrendingSearchRow: View {
    let rank: Int
    let title: String
    let category: String
    
    var body: some View {
        HStack {
            Text("#\(rank)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(category)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "arrow.up.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(8)
    }
}



struct ErrorView: View {
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Error Icon
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            // Error Title
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            // Error Message
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            // Refresh Button
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                        .font(.subheadline)
                    
                    Text(buttonTitle)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(32)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
}

#Preview {
    SearchView()
} 
