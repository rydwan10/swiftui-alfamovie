//
//  MovieCard.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import SwiftUI

struct MovieCard: View {
        let title: String
        let genre: String
        let rating: String
        let imageName: String
        let posterURL: String?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                // Poster Image
                if let posterURL = posterURL, let url = URL(string: posterURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(2/3, contentMode: .fit)
                            .frame(width: 140, height: 210)
                            .cornerRadius(12)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.secondary.opacity(0.1))
                            .frame(width: 140, height: 210)
                            .overlay(
                                ProgressView()
                                    .scaleEffect(0.6)
                            )
                    }
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.secondary.opacity(0.1))
                        .frame(width: 140, height: 210)
                        .overlay(
                            Image(systemName: imageName)
                                .font(.title)
                                .foregroundColor(.secondary)
                        )
                }
                
                // Movie Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(genre)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        
                        Text(rating)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
                .frame(width: 140, alignment: .leading)
            }
            .frame(width: 140, height: 280)
        }
    }

#Preview {
    MovieCard(title: "The Dark Knight", genre: "Action, Drama, Crime", rating: "8.5", imageName: "movie.fill", posterURL: "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg")
}
