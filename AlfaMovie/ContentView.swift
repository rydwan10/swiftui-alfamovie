//
//  ContentView.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                        
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            WatchlistView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Watchlist")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(Color("AlfaRed"))
    }
}

#Preview {
    ContentView()
}
