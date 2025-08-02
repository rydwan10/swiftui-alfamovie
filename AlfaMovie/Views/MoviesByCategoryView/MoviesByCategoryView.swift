//
//  MoviesByCategoryView.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import SwiftUI

struct MoviesByCategoryView: View {
    let category: String
    let categoryId: Int?
    @StateObject private var viewModel = MoviesByCategoryViewModel()
    private let genreService = GenreService.shared
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                movieItems
                loadingSkeletons
            }
            .padding()
        }
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            viewModel.refreshMovies()
        }
        .overlay(
            overlayContent
        )
        .onAppear {
            if viewModel.movies.isEmpty {
                viewModel.loadMovies(categoryId: categoryId)
            }
        }
    }
    
    private var movieItems: some View {
        ForEach(Array(viewModel.movies.enumerated()), id: \.element.id) { index, movie in
            MovieGridItemView(
                movie: movie,
                genreService: genreService,
                isLast: index == viewModel.movies.count - 1,
                loadMoreAction: viewModel.loadMoreMovies
            )
        }
    }
    
    private var loadingSkeletons: some View {
        Group {
            if viewModel.isLoadingMore {
                ForEach(0..<4, id: \.self) { _ in
                    skeletonCard
                }
            }
        }
    }
    
    @ViewBuilder
    private var overlayContent: some View {
        if viewModel.isLoading && viewModel.movies.isEmpty {
            loadingView
        } else if let errorMessage = viewModel.errorMessage {
            errorView(errorMessage)
        } else if viewModel.movies.isEmpty && !viewModel.isLoading {
            emptyView
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading \(category) movies...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private func errorView(_ message: String) -> some View {
        ErrorView(
            title: "Failed to load movies",
            message: message,
            buttonTitle: "Try Again",
            action: {
                viewModel.refreshMovies()
            }
        )
    }
    
    private var emptyView: some View {
        VStack(spacing: 20) {
            Image(systemName: "film")
                .font(.title)
                .foregroundColor(.secondary)
            
            Text("No movies found")
                .font(.headline)
                .fontWeight(.medium)
            
            Text("Try a different category")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var skeletonCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.1))
                .frame(width: 140, height: 210)
                .overlay(
                    ProgressView()
                        .scaleEffect(0.6)
                )
            
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 100, height: 16)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 80, height: 12)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 60, height: 12)
            }
            .frame(width: 140, alignment: .leading)
        }
        .frame(width: 140, height: 280)
    }
}

struct MovieGridItemView: View {
    let movie: Movie
    let genreService: GenreService
    let isLast: Bool
    let loadMoreAction: () -> Void

    var body: some View {
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
        .onAppear {
            if isLast {
                loadMoreAction()
            }
        }
    }
}

#Preview {
    NavigationView {
        MoviesByCategoryView(category: "Action", categoryId: 28)
    }
}
