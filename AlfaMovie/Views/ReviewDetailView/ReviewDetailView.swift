//
//  ReviewDetailView.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import SwiftUI

struct ReviewDetailView: View {
    let review: Review
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with author info
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top, spacing: 12) {
                        // Avatar
                        if let avatarURL = review.authorDetails.avatarURL {
                            AsyncImage(url: avatarURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            } placeholder: {
                                Circle()
                                    .fill(Color.secondary.opacity(0.2))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.title2)
                                            .foregroundColor(.secondary)
                                    )
                            }
                        } else {
                            Circle()
                                .fill(Color.secondary.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.title2)
                                        .foregroundColor(.secondary)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(review.author)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("@\(review.authorDetails.username)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            // Date
                            Text(formatDate(review.createdAt))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Rating display
                        VStack(spacing: 4) {
                            HStack(spacing: 2) {
                                ForEach(1...5, id: \.self) { index in
                                    Image(systemName: index <= Int(review.authorDetails.rating ?? 0) ? "star.fill" : "star")
                                        .font(.caption)
                                        .foregroundColor(.yellow)
                                }
                            }
                            
                            Text(String(format: "%.1f", review.authorDetails.rating ?? 0))
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.yellow.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.bottom, 8)
                
                Divider()
                
                // Review content
                VStack(alignment: .leading, spacing: 16) {
                    Text("Review")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(review.content)
                        .font(.body)
                        .lineSpacing(6)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                
                
                Spacer(minLength: 20)
            }
            .padding()
        }
        .navigationTitle("Review Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        
        return dateString
    }
}

#Preview {
    NavigationView {
        ReviewDetailView(review: Review(
            id: "1",
            author: "John Doe",
            authorDetails: AuthorDetails(
                name: "John Doe",
                username: "johndoe",
                avatarPath: nil,
                rating: 8.5
            ),
            content: "This is a comprehensive review of the movie. The film delivers an outstanding performance with compelling storytelling, excellent cinematography, and memorable performances from the cast. The director's vision is clearly executed throughout the narrative, creating an immersive experience for the audience. The screenplay is well-crafted with engaging dialogue and well-developed characters. The visual effects are stunning and serve the story effectively. Overall, this is a must-watch film that will leave a lasting impression on viewers.",
            createdAt: "2024-01-15T10:30:00.000Z",
            updatedAt: "2024-01-15T10:30:00.000Z",
            url: "https://example.com/review",

        ))
    }
}