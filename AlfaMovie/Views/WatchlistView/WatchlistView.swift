//
//  WatchlistView.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import SwiftUI

struct WatchlistView: View {
    @State private var selectedTab = "All"
    
    let tabs = ["All", "Movies", "TV Shows", "Watching"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("My Watchlist")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        // Sort action
                    }) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .padding()
                
                // Tab Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(tabs, id: \.self) { tab in
                            WatchlistTabPill(
                                title: tab,
                                isSelected: selectedTab == tab
                            ) {
                                selectedTab = tab
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
                
                // Watchlist Content
                ScrollView {
                    VStack(spacing: 20) {
                        // Continue Watching
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Continue Watching")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(1...5, id: \.self) { index in
                                        ContinueWatchingCard(
                                            title: "Movie \(index)",
                                            progress: Double(index) * 0.2,
                                            episode: "Episode \(index)",
                                            timeLeft: "\(index * 15) min left"
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // My List
                        VStack(alignment: .leading, spacing: 12) {
                            Text("My List")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(1...9, id: \.self) { index in
                                    WatchlistItemCard(
                                        title: "Watchlist Item \(index)",
                                        genre: "Action",
                                        rating: "8.\(index)",
                                        isWatched: index % 3 == 0
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Recently Added
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recently Added")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                ForEach(1...5, id: \.self) { index in
                                    RecentlyAddedRow(
                                        title: "Recently Added \(index)",
                                        genre: "Drama",
                                        addedDate: "\(index) days ago"
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}

struct WatchlistTabPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? Color("AlfaRed") : Color.secondary.opacity(0.1))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(25)
        }
    }
}

struct ContinueWatchingCard: View {
    let title: String
    let progress: Double
    let episode: String
    let timeLeft: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        colors: [Color("AlfaRed"), Color("AlfaBlue")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 200, height: 120)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(episode)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Text(timeLeft)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.secondary.opacity(0.2))
                            .frame(height: 4)
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.blue)
                            .frame(width: geometry.size.width * progress, height: 4)
                    }
                }
                .frame(height: 4)
            }
        }
        .frame(width: 200)
    }
}

struct WatchlistItemCard: View {
    let title: String
    let genre: String
    let rating: String
    let isWatched: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(height: 100)
                    .overlay(
                        Image(systemName: "film")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    )
                
                if isWatched {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.green)
                        .padding(4)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(genre)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                    
                    Text(rating)
                        .font(.caption2)
                        .fontWeight(.medium)
                }
            }
        }
    }
}

struct RecentlyAddedRow: View {
    let title: String
    let genre: String
    let addedDate: String
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.1))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "film")
                        .font(.title3)
                        .foregroundColor(.secondary)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(genre)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Added \(addedDate)")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Button(action: {
                // Remove action
            }) {
                Image(systemName: "xmark.circle")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    WatchlistView()
} 
