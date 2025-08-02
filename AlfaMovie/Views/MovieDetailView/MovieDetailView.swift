//
//  MovieDetailView.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import SwiftUI

struct MovieDetailView: View {
    let movieId: Int
    @StateObject private var viewModel: MovieDetailViewModel
    
    init(movieId: Int) {
        self.movieId = movieId
        self._viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieId: movieId))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Movie Header
                ZStack(alignment: .bottom) {
                    // Background Image
                    if let movie = viewModel.movie, let backdropURL = movie.backdropURL {
                        AsyncImage(url: URL(string: backdropURL)) { image in
                            image
                                .resizable()
                                // .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .clipped()
                                .overlay(
                                    LinearGradient(
                                        colors: [.clear, .black.opacity(0.7)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 0)
                                .fill(LinearGradient(
                                    colors: [Color("AlfaRed").opacity(0.8), Color("AlfaBlue").opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(height: 300)
                                .overlay(
                                    ProgressView()
                                        .scaleEffect(1.2)
                                        .foregroundColor(.white)
                                )
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(LinearGradient(
                                colors: [Color("AlfaRed").opacity(0.8), Color("AlfaBlue").opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 300)
                    }
                    
                    // Movie Info Overlay
                    VStack(spacing: 16) {
                        // Movie Poster
                        if let movie = viewModel.movie, let posterURL = movie.posterURL {
                            AsyncImage(url: URL(string: posterURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(2/3, contentMode: .fit)
                                    .frame(width: 120, height: 180)
                                    .cornerRadius(12)
                                    .shadow(radius: 8)
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.secondary.opacity(0.1))
                                    .frame(width: 120, height: 180)
                                    .overlay(
                                        ProgressView()
                                            .scaleEffect(0.8)
                                    )
                            }
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.secondary.opacity(0.1))
                                .frame(width: 120, height: 180)
                                .overlay(
                                    Image(systemName: "film")
                                        .font(.title)
                                        .foregroundColor(.secondary)
                                )
                        }
                        
                        VStack(spacing: 8) {
                            Text(viewModel.movie?.title ?? "Loading...")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            if let movie = viewModel.movie {
                                Text("\(movie.formattedReleaseDate) • \(movie.formattedRating)")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            } else {
                                Text("Loading...")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            HStack(spacing: 16) {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text(viewModel.movie?.formattedRating ?? "0.0")
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                
                                if let movie = viewModel.movie {
                                    Text(movie.adult ? "R" : "PG-13")
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(4)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
                
                // Action Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        // Play action
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                            Text("Play")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color("AlfaRed"))
                        .cornerRadius(25)
                    }
                    
                    Button(action: {
                        viewModel.toggleWatchlist()
                    }) {
                        Image(systemName: viewModel.isInWatchlist ? "bookmark.fill" : "bookmark")
                            .font(.title2)
                            .foregroundColor(viewModel.isInWatchlist ? .blue : .primary)
                    }
                    
                    Button(action: {
                        viewModel.toggleLike()
                    }) {
                        Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(viewModel.isLiked ? .red : .primary)
                    }
                    
                    Button(action: {
                        // Share action
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.vertical, 20)
                
                // Trailer Section
                if !viewModel.trailers.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Trailers")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.trailers.prefix(3)) { trailer in
                                    TrailerMovieCard(trailer: trailer)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 20)
                }
                
                // Tab Navigation
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(viewModel.tabs, id: \.self) { tab in
                            Button(action: {
                                viewModel.selectTab(tab)
                            }) {
                                Text(tab)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(viewModel.selectedTab == tab ? Color("AlfaRed") : .secondary)
                                    .padding(.bottom, 8)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 2)
                                            .foregroundColor(viewModel.selectedTab == tab ? Color("AlfaRed") : .clear)
                                            .offset(y: 8)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
                
                // Loading State
                if viewModel.isLoading {
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        
                        Text("Loading movie details...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 50)
                }
                // Error State
                else if let errorMessage = viewModel.errorMessage {
                    ErrorLoadDataView(
                        title: "Error loading movie",
                        message: errorMessage,
                        buttonTitle: "Try Again",
                        action: {
                            viewModel.loadMovieDetails(movieId: movieId)
                        }
                    )
                }
                // Content
                else {
                    // Tab Content
                    VStack(spacing: 20) {
                        switch viewModel.selectedTab {
                        case "Overview":
                            OverviewTab(movie: viewModel.movie)
                        case "Cast":
                            CastTab(cast: viewModel.cast, viewModel: viewModel)
                        case "Reviews":
                            ReviewsTab(movieId: movieId, viewModel: viewModel)
                        case "Related":
                            RelatedTab(movies: viewModel.relatedMovies)
                        default:
                            OverviewTab(movie: viewModel.movie)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle(viewModel.movie?.title ?? "Movie Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OverviewTab: View {
    let movie: Movie?
    private let genreService = GenreService.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Synopsis
            VStack(alignment: .leading, spacing: 12) {
                Text("Synopsis")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(movie?.overview ?? "Loading...")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
            
            // Movie Details
            if let movie = movie {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Details")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 8) {
                        DetailRow(title: "Genre", value: genreService.getGenreNames(for: movie.genreIds ?? []) ?? "Action")
                        DetailRow(title: "Release Date", value: movie.formattedReleaseDate)
                        DetailRow(title: "Rating", value: movie.adult ? "R" : "PG-13")
                        DetailRow(title: "Runtime", value: formatRuntime(movie.runtime))
                        DetailRow(title: "Language", value: movie.originalLanguage.uppercased())
                        DetailRow(title: "Status", value: movie.status ?? "Released")
                        DetailRow(title: "Budget", value: formatBudget(movie.budget))
                        DetailRow(title: "Revenue", value: formatRevenue(movie.revenue))
                    }
                }
            }
        }
    }
    
    private func formatRuntime(_ runtime: Int?) -> String {
        guard let runtime = runtime, runtime > 0 else { return "Unknown" }
        let hours = runtime / 60
        let minutes = runtime % 60
        return "\(hours)h \(minutes)m"
    }
    
    private func formatBudget(_ budget: Int?) -> String {
        guard let budget = budget, budget > 0 else { return "Unknown" }
        if budget >= 1_000_000_000 {
            return "$\(budget / 1_000_000_000)B"
        } else if budget >= 1_000_000 {
            return "$\(budget / 1_000_000)M"
        } else {
            return "$\(budget)"
        }
    }
    
    private func formatRevenue(_ revenue: Int?) -> String {
        guard let revenue = revenue, revenue > 0 else { return "Unknown" }
        if revenue >= 1_000_000_000 {
            return "$\(revenue / 1_000_000_000)B"
        } else if revenue >= 1_000_000 {
            return "$\(revenue / 1_000_000)M"
        } else {
            return "$\(revenue)"
        }
    }
}

struct CastTab: View {
    let cast: [CastMember]
    let viewModel: MovieDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Cast & Crew")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                if viewModel.isLoadingCast {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            
            if viewModel.isLoadingCast {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.2)
                    
                    Text("Loading cast...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else if cast.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "person.3")
                        .font(.title)
                        .foregroundColor(.secondary)
                    
                    Text("No cast information")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Text("Cast details not available")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(cast) { member in
                        CastCard(
                            name: member.name,
                            character: member.character,
                            role: member.knownForDepartment,
                            profileURL: member.profileURL?.absoluteString
                        )
                    }
                }
            }
        }
    }
}

struct ReviewsTab: View {
    let movieId: Int
    let viewModel: MovieDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Reviews")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
            
            }
            
            if viewModel.isLoadingReviews {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.2)
                    
                    Text("Loading reviews...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else if viewModel.reviews.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "text.bubble")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text("No reviews yet")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Text("Be the first to review this movie!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                VStack(spacing: 16) {
                    ForEach(viewModel.reviews) { review in
                        ReviewCard(review: review)
                    }
                }
            }
        }
    }
}

struct RelatedTab: View {
    let movies: [Movie]
    private let genreService = GenreService.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Related Movies")
                .font(.title2)
                .fontWeight(.bold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(movies) { movie in
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
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

struct AwardRow: View {
    let award: String
    let category: String
    let status: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(award)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(category)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(status)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(status == "Won" ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                .foregroundColor(status == "Won" ? .green : .orange)
                .cornerRadius(4)
        }
        .padding(.vertical, 4)
    }
}

struct CastCard: View {
    let name: String
    let character: String
    let role: String
    let profileURL: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Profile Image
            if let profileURL = profileURL, let url = URL(string: profileURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(Color.secondary.opacity(0.1))
                        .frame(width: 140, height: 140)
                        .overlay(
                            ProgressView()
                                .scaleEffect(0.6)
                        )
                }
            } else {
                Circle()
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 140, height: 140)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.title)
                            .foregroundColor(.secondary)
                    )
            }
            
            // Cast Info
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text("as \(character)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text(role)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .lineLimit(1)
            }
            .frame(width: 140, alignment: .leading)
        }
        .frame(width: 140, height: 220)
    }
}

struct ReviewCard: View {
    let review: Review
    
    var body: some View {
        NavigationLink(destination: ReviewDetailView(review: review)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    // Avatar
                    if let avatarURL = review.authorDetails.avatarURL {
                        AsyncImage(url: avatarURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .fill(Color.secondary.opacity(0.2))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                )
                        }
                    } else {
                        Circle()
                            .fill(Color.secondary.opacity(0.2))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(review.author)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Text(review.authorDetails.username)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= Int(review.authorDetails.rating ?? 0) ? "star.fill" : "star")
                                .font(.caption)
                                .foregroundColor(.yellow)
                        }
                    }
                }
                
                Text(review.content)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineSpacing(2)
                    .lineLimit(4)
                    .truncationMode(.tail)
                
                HStack {
                    Text("Tap to read full review")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.05))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}



struct TrailerMovieCard: View {
    let trailer: Trailer
    @State private var showTrailerPlayer = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Thumbnail Image
            ZStack {
                if let thumbnailURL = trailer.thumbnailURL {
                    AsyncImage(url: thumbnailURL) { image in
                        image
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fit)
                            .frame(width: 140, height: 80)
                            .cornerRadius(12)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("AlfaRed").opacity(0.1))
                            .frame(width: 140, height: 80)
                            .overlay(
                                ProgressView()
                                    .scaleEffect(0.6)
                            )
                    }
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.secondary.opacity(0.1))
                        .frame(width: 140, height: 80)
                        .overlay(
                            Image(systemName: "play.rectangle")
                                .font(.title)
                                .foregroundColor(Color("AlfaBlue"))
                        )
                }
                
                // Play button overlay
                Circle()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "play.fill")
                            .font(.title3)
                            .foregroundColor(Color("AlfaBlue"))
                    )
            }
            
            // Trailer Info
            VStack(alignment: .leading, spacing: 6) {
                Text(trailer.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(trailer.site)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
            }
            .frame(width: 140, alignment: .leading)
        }
        .frame(width: 140, height: 140)
        .onTapGesture {
            showTrailerPlayer = true
        }
        .fullScreenCover(isPresented: $showTrailerPlayer) {
            TrailerPlayerView(trailer: trailer, isPresented: $showTrailerPlayer)
        }
    }
}

#Preview {
    NavigationView {
        MovieDetailView(movieId: 550)
    }
}

