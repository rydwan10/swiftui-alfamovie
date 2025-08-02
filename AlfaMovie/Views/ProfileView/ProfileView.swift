//
//  ProfileView.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var isNotificationsEnabled = true
    @State private var isAutoPlayEnabled = false
    @State private var selectedQuality = "HD"
    
    let qualityOptions = ["SD", "HD", "4K"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack {
                        HStack(spacing: 16) {
                            // Profile Image
                            ZStack {
                                Circle()
                                    .fill(
                                        Color("AlfaRed")
                                    )
                                    .frame(width: 100, height: 100)
                                
                                Text("MR")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Muhammad Rydwan")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text("Premium Member")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            
                            
                        }
                        
                        
                        // Stats
                        HStack(spacing: 40) {
                            StatItem(title: "Watched", value: "127")
                            StatItem(title: "Watchlist", value: "45")
                            StatItem(title: "Reviews", value: "23")
                        }
                    }.padding()
                        .background(Color.secondary.opacity(0.05))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quick Actions")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            ProfileActionRow(
                                icon: "heart.fill",
                                title: "My Favorites",
                                subtitle: "23 movies",
                                color: Color("AlfaBlue")
                            )
                            
                            ProfileActionRow(
                                icon: "star.fill",
                                title: "My Reviews",
                                subtitle: "12 reviews",
                                color: Color("AlfaBlue")
                            )
                            
                            ProfileActionRow(
                                icon: "clock.fill",
                                title: "Watch History",
                                subtitle: "Last 30 days",
                                color: Color("AlfaBlue")
                            )
                            
                            ProfileActionRow(
                                icon: "gear",
                                title: "Settings",
                                subtitle: "App preferences",
                                color: Color("AlfaBlue")
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Settings
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Settings")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            SettingsRow(
                                icon: "bell.fill",
                                title: "Notifications",
                                subtitle: "Get updates about new releases",
                                isToggle: true,
                                isOn: $isNotificationsEnabled
                            )
                            
                            Divider()
                                .padding(.leading, 50)
                            
                            SettingsRow(
                                icon: "play.fill",
                                title: "Auto Play",
                                subtitle: "Automatically play next episode",
                                isToggle: true,
                                isOn: $isAutoPlayEnabled
                            )
                            
                            Divider()
                                .padding(.leading, 50)
                            
                            SettingsRow(
                                icon: "tv.fill",
                                title: "Video Quality",
                                subtitle: selectedQuality,
                                isToggle: false,
                                isOn: .constant(false)
                            ) {
                                // Quality selection action
                            }
                        }
                        .background(Color.secondary.opacity(0.05))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // Account
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Account")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            AccountRow(
                                icon: "person.fill",
                                title: "Edit Profile",
                                color: Color("AlfaBlue")
                            )
                            
                            Divider()
                                .padding(.leading, 50)
                            
                            AccountRow(
                                icon: "creditcard.fill",
                                title: "Billing & Subscription",
                                color: Color("AlfaBlue")
                            )
                            
                            Divider()
                                .padding(.leading, 50)
                            
                            AccountRow(
                                icon: "questionmark.circle.fill",
                                title: "Help & Support",
                                color: Color("AlfaBlue")
                            )
                            
                            Divider()
                                .padding(.leading, 50)
                            
                            AccountRow(
                                icon: "arrow.right.square.fill",
                                title: "Sign Out",
                                color: Color("AlfaRed")
                            )
                        }
                        .background(Color.secondary.opacity(0.05))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // App Info
                    VStack(spacing: 8) {
                        Text("AlfaMovie v1.0.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("© 2025 AlfaMovie. All rights reserved.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                }
                .padding(.vertical)
            }
            .navigationTitle("Profile")
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct ProfileActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(8)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let isToggle: Bool
    @Binding var isOn: Bool
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color("AlfaBlue"))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isToggle {
                Toggle("", isOn: $isOn)
                    .labelsHidden()
            } else {
                Button(action: {
                    action?()
                }) {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

struct AccountRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ProfileView()
} 
