//
//  RefreshableView.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import SwiftUI

struct RefreshableView<Content: View>: View {
    let action: () -> Void
    let content: Content
    
    @State private var isRefreshing = false
    
    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        content
            .refreshable {
                isRefreshing = true
                action()
                isRefreshing = false
            }
    }
} 