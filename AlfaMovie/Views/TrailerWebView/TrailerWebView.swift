//
//  TrailerWebView.swift
//  AlfaMovie
//
//  Created by Muhammad Rydwan on 01/08/25.
//

import SwiftUI
import WebKit

struct TrailerWebView: UIViewRepresentable {
    let trailer: Trailer
    @Binding var isPresented: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = trailer.youtubeURL {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: TrailerWebView
        
        init(_ parent: TrailerWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Inject CSS to hide YouTube UI elements for better mobile experience
            let css = """
            body { margin: 0; padding: 0; }
            .ytp-chrome-top { display: none !important; }
            .ytp-chrome-bottom { display: none !important; }
            .ytp-pause-overlay { display: none !important; }
            """
            
            let js = """
            var style = document.createElement('style');
            style.innerHTML = '\(css)';
            document.head.appendChild(style);
            """
            
            webView.evaluateJavaScript(js)
        }
    }
}

struct TrailerPlayerView: View {
    let trailer: Trailer
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Close") {
                        isPresented = false
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text(trailer.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button("Open in YouTube") {
                        if let url = trailer.youtubeURL {
                            UIApplication.shared.open(url)
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
                .padding()
                .background(Color(.systemBackground))
                
                // WebView
                TrailerWebView(trailer: trailer, isPresented: $isPresented)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .navigationBarHidden(true)
    }
} 