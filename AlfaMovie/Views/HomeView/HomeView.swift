//
//  HomeView.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var currentFeaturedIndex = 0
    @State private var autoSwipeTimer: Timer?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                               
                                HStack {
                                    Image("Logo")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        
                                    Text("AlfaMovie")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                }
                               

                                Text("Welcome back, Rydwan!")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                    
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                // Notification action
                            }) {
                                Image(systemName: "bell")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Featured Movies
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Now Playing")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            if viewModel.featuredMovies.isEmpty {
                                // Loading state
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(
                                        colors: [Color("AlfaRed").opacity(0.8), Color("AlfaBlue").opacity(0.6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(height: 200)
                                    .overlay(
                                        ProgressView()
                                            .scaleEffect(1.2)
                                            .foregroundColor(.white)
                                    )
                                    .padding(.horizontal)
                            } else {
                                VStack(spacing: 12) {
                                    TabView(selection: $currentFeaturedIndex) {
                                        ForEach(Array(viewModel.featuredMovies.enumerated()), id: \.element.id) { index, movie in
                                            NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                                                FeaturedMovieCard(movie: movie)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            .tag(index)
                                        }
                                    }
                                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                    .frame(height: 200)
                                    .onAppear {
                                        startAutoSwipe()
                                    }
                                    .onDisappear {
                                        stopAutoSwipe()
                                    }
                                    .onChange(of: currentFeaturedIndex, initial: true) { _,  _ in
                                        // Restart timer when user manually swipes
                                        stopAutoSwipe()
                                        startAutoSwipe()
                                    }
                                    
                                    // Custom page indicator below the cards
                                    HStack(spacing: 8) {
                                        ForEach(0..<viewModel.featuredMovies.count, id: \.self) { index in
                                            Circle()
                                                .fill(index == currentFeaturedIndex ? Color.blue : Color.gray.opacity(0.3))
                                                .frame(width: 8, height: 8)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Categories
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Categories")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    NavigationLink(destination: MoviesByCategoryView(category: "Action", categoryId: 28)) {
                                        CategoryCard(title: "Action", icon: "flame.fill", color: .red)
                                    }
                                    NavigationLink(destination: MoviesByCategoryView(category: "Comedy", categoryId: 35)) {
                                        CategoryCard(title: "Comedy", icon: "face.smiling.fill", color: .orange)
                                    }
                                    NavigationLink(destination: MoviesByCategoryView(category: "Drama", categoryId: 18)) {
                                        CategoryCard(title: "Drama", icon: "theatermasks.fill", color: .purple)
                                    }
                                    NavigationLink(destination: MoviesByCategoryView(category: "Horror", categoryId: 27)) {
                                        CategoryCard(title: "Horror", icon: "eye.fill", color: .black)
                                    }
                                    NavigationLink(destination: MoviesByCategoryView(category: "Science Fiction", categoryId: 878)) {
                                        CategoryCard(title: "Sci-Fi", icon: "atom", color: .blue)
                                    }
                                }
                                .foregroundStyle(.black)
                                
                                .padding(.horizontal)
                            }
                        }
                        
                        // Trending Movies
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Trending Now")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                if viewModel.isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                }
                            }
                            .padding(.horizontal)
                            
                            if viewModel.isLoading {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(0..<5, id: \.self) { _ in
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.secondary.opacity(0.1))
                                                .frame(width: 120, height: 180)
                                                .overlay(
                                                    ProgressView()
                                                )
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                                                            ForEach(viewModel.trendingMovies) { movie in
                                            NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                                                MovieCard(
                                                    title: movie.title,
                                                    genre: movie.genre,
                                                    rating: movie.rating,
                                                    imageName: movie.imageName,
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
                        
                        // Recently Added
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recently Added")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(viewModel.recentlyAddedMovies) { movie in
                                    NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                                        MovieCard(
                                            title: movie.title,
                                            genre: movie.genre,
                                            rating: movie.rating,
                                            imageName: movie.imageName,
                                            posterURL: movie.posterURL
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .onAppear {
                                        // Trigger infinite scroll when reaching the last few items
                                        if movie.id == viewModel.recentlyAddedMovies.last?.id {
                                            viewModel.loadMoreRecentlyAddedMovies()
                                        }
                                    }
                                }
                                
                                // Loading indicator for infinite scroll
                                if viewModel.isLoadingMore {
                                    ForEach(0..<4, id: \.self) { _ in
                                        VStack(alignment: .leading, spacing: 8) {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.secondary.opacity(0.1))
                                                .frame(height: 120)
                                                .overlay(
                                                    ProgressView()
                                                        .scaleEffect(0.8)
                                                )
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(Color.secondary.opacity(0.1))
                                                    .frame(height: 12)
                                                
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(Color.secondary.opacity(0.1))
                                                    .frame(height: 8)
                                            }
                                        }
                                        .frame(width: 120)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Error Message
                        if let errorMessage = viewModel.errorMessage {
                            VStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                
                                Text("Error loading trending movies")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Button("Try Again") {
                                    viewModel.refreshTrendingMovies()
                                }
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(12)
                                                    .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .refreshable {
                viewModel.loadFeaturedMovies()
                viewModel.refreshTrendingMovies()
                viewModel.loadRecentlyAddedMovies()
            }
        }
        }
    
    // MARK: - Auto Swipe Methods
    private func startAutoSwipe() {
        guard !viewModel.featuredMovies.isEmpty else { return }
        
        autoSwipeTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentFeaturedIndex = (currentFeaturedIndex + 1) % viewModel.featuredMovies.count
            }
        }
    }
    
    private func stopAutoSwipe() {
        autoSwipeTimer?.invalidate()
        autoSwipeTimer = nil
    }
}

struct CategoryCard: View {
        let title: String
        let icon: String
        let color: Color
        
        var body: some View {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.2))
                    .clipShape(Circle())
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
            }
            .frame(width: 80)
            .padding(.vertical, 12)
            .background(Color("AlfaBlue"))
            .cornerRadius(12)
        }
    }
    
    struct FeaturedMovieCard: View {
        let movie: MovieItem
        
        var body: some View {
            ZStack(alignment: .bottomLeading) {
                // Background Image
                if let posterURL = movie.posterURL, let url = URL(string: posterURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(
                                colors: [Color("AlfaRed").opacity(0.8), Color("AlfaBlue").opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .overlay(
                                ProgressView()
                                    .scaleEffect(1.2)
                                    .foregroundColor(.white)
                            )
                    }
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [Color("AlfaRed").opacity(0.8), Color("AlfaBlue").opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                }
                
                // Gradient overlay for better text readability
                LinearGradient(
                    colors: [.clear, .black.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Movie Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    Text("\(movie.genre) • \(movie.rating) ★")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack(spacing: 12) {
                        Button("Watch Now") {
                            // Watch action
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color("AlfaRed").opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .font(.caption)
                        .fontWeight(.semibold)
                        
                        Button("Trailer") {
                            // Trailer action
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color("AlfaBlue").opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .font(.caption)
                        .fontWeight(.semibold)
                    }
                }
                .padding()
            }
            .cornerRadius(16)
            .shadow(radius: 8)
        }
    }
    
    

#Preview {
    HomeView()
} 
