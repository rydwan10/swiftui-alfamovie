//
//  ErrorLoadDataView.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import SwiftUI

struct ErrorLoadDataView: View {
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void
    
    init(
        title: String = "Error loading data",
        message: String,
        buttonTitle: String = "Try Again",
        action: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title)
                .foregroundColor(.orange)
            
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(buttonTitle) {
                action()
            }
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.blue)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color.orange.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Preview
struct ErrorLoadDataView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ErrorLoadDataView(
                title: "Network Error",
                message: "Unable to connect to the server. Please check your internet connection and try again.",
                action: {}
            )
            
            ErrorLoadDataView(
                title: "Failed to load movie",
                message: "Something went wrong while loading the movie details.",
                buttonTitle: "Retry",
                action: {}
            )
            
            ErrorLoadDataView(
                message: "An unexpected error occurred.",
                action: {}
            )
        }
        .padding()
        .background(Color(.systemBackground))
    }
} 