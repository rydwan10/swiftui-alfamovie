# 🎬 AlfaMovie

> **A modern iOS movie discovery app built with SwiftUI, RxSwift, and TMDB API**

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![RxSwift](https://img.shields.io/badge/RxSwift-6.9.0-purple.svg)](https://github.com/ReactiveX/RxSwift)

---
<img width="256" height="256" alt="AlfaMovie" src="https://github.com/user-attachments/assets/0364da9e-d8f0-47da-be21-0572f6fbcdc6" />


---

## ✨ Features

### 🏠 **Home Screen**
- **Now Playing** - Auto-swiping featured movies with custom page indicators
- **Categories** - Interactive movie genre navigation
- **Trending Now** - Real-time trending movies with pull-to-refresh
- **Recently Added** - Infinite scroll with pagination
- **Branded Header** - Custom AlfaMovie branding with notification bell

### 🔍 **Search & Discovery**
- **Smart Search** - Debounced search with real-time results
- **Popular Movies** - Dynamic popular movie recommendations
- **Trending Movies** - Current trending content
- **Genre Filtering** - Browse movies by category
- **Search History** - Intelligent search suggestions

### 🎭 **Movie Details**
- **Rich Information** - Complete movie metadata (budget, revenue, runtime, etc.)
- **Cast & Crew** - Beautiful cast member cards with profile images
- **Movie Reviews** - User reviews with author avatars and ratings
- **Related Movies** - Smart movie recommendations
- **YouTube Trailers** - In-app trailer viewing with custom WebView
- **Movie Posters** - High-quality poster and backdrop images

### 🎨 **UI/UX Excellence**
- **Modern Design** - Clean, intuitive interface with custom colors
- **Loading States** - Elegant loading animations and skeleton screens
- **Error Handling** - User-friendly error messages with retry options
- **Responsive Layout** - Optimized for all iOS devices
- **Smooth Animations** - Fluid transitions and micro-interactions

---

## 🏗️ Architecture

### **MVVM + RxSwift**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Views       │    │   ViewModels    │    │    Services     │
│                 │    │                 │    │                 │
│ • HomeView      │◄──►│ • HomeViewModel  │◄──►│ • TMDBService   │
│ • SearchView    │    │ • SearchViewModel│    │ • GenreService  │
│ • MovieDetail   │    │ • MovieDetailVM  │    │                 │
│ • Components    │    │ • MoviesByCatVM  │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### **Project Structure**
```
AlfaMovie/
├── 📱 Views/
│   ├── 🏠 HomeView/
│   ├── 🔍 SearchView/
│   ├── 🎭 MovieDetailView/
│   ├── 📋 WatchlistView/
│   ├── 👤 ProfileView/
│   ├── 🎬 MoviesByCategoryView/
│   └── 🧩 Components/
│       ├── MovieCard.swift
│       └── ErrorLoadDataView.swift
├── 🧠 ViewModels/
│   ├── HomeViewModel.swift
│   ├── SearchViewModel.swift
│   ├── MovieDetailViewModel.swift
│   └── MoviesByCategoryViewModel.swift
├── 📊 Models/
│   ├── Movie.swift
│   ├── Casts.swift
│   ├── Review.swift
│   ├── Genre.swift
│   └── Trailer.swift
├── 🌐 Services/
│   ├── TMDBService.swift
│   └── GenreService.swift
├── 🛠️ Utilities/
│   └── FormattingUtils.swift
└── 🎨 Resources/
    ├── Assets.xcassets
    └── Color.xcassets
```

---

## 🚀 Getting Started

### **Prerequisites**
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+
- RxSwift 6.9.0

### **Installation**

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/AlfaMovie.git
   cd AlfaMovie
   ```

2. **Open in Xcode**
   ```bash
   open AlfaMovie.xcodeproj
   ```

3. **Configure API Key**
   - Get your TMDB API key from [The Movie Database](https://www.themoviedb.org/settings/api)
   - Replace the API key in `TMDBService.swift`:
   ```swift
   private let apiKey = "YOUR_API_KEY_HERE"
   ```

4. **Build and Run**
   - Select your target device/simulator
   - Press `Cmd + R` to build and run

---

## 🧪 Testing

### **Unit Tests**
```bash
# Run all tests
xcodebuild test -scheme AlfaMovie -destination 'platform=iOS Simulator,name=iPhone 16'

# Run specific test suite
xcodebuild test -scheme AlfaMovie -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:AlfaMovieTests/FormattingUtilsTests
```

### **Test Coverage**
- ✅ **FormattingUtils** - Comprehensive utility function testing
- ✅ **Runtime formatting** - Hours and minutes conversion
- ✅ **Budget/Revenue** - Currency formatting with B/M suffixes
- ✅ **Date formatting** - Custom date string formatting
- ✅ **File size formatting** - ByteCountFormatter integration
- ✅ **Edge cases** - Nil, negative, and zero value handling

---

## 🛠️ Technical Stack

### **Frontend**
- **SwiftUI** - Modern declarative UI framework
- **RxSwift** - Reactive programming for data flow
- **RxCocoa** - RxSwift extensions for Cocoa

### **Backend Integration**
- **TMDB API** - The Movie Database REST API
- **URLSession** - Network requests with RxSwift
- **JSONDecoder** - JSON parsing and model mapping

### **Data Management**
- **SwiftData** - Local data persistence for genre caching
- **BehaviorRelay** - Observable data streams
- **@Published** - SwiftUI property wrappers

### **Utilities**
- **FormattingUtils** - Custom formatting utilities
- **AsyncImage** - Asynchronous image loading
- **WKWebView** - In-app web content (trailers)

---

## 🎨 Design System

### **Color Palette**
```swift
// Brand Colors
AlfaRed: #cc1b28    // Primary brand color
AlfaBlue: #0055ae   // Secondary brand color

// System Colors
Primary: .primary
Secondary: .secondary
Background: .systemBackground
```

### **Typography**
- **Title**: `.title` - App branding and headers
- **Headline**: `.headline` - Section titles
- **Subheadline**: `.subheadline` - Movie titles
- **Body**: `.body` - Content text
- **Caption**: `.caption` - Metadata and ratings

### **Components**
- **MovieCard** - Reusable movie display component
- **ErrorLoadDataView** - Consistent error handling
- **FeaturedMovieCard** - Hero movie display
- **CastCard** - Cast member information
- **ReviewCard** - User review display

---

## 📱 Screenshots

### **Home Screen**
- Auto-swiping featured movies
- Category navigation
- Trending and recently added sections

### **Search Screen**
- Debounced search input
- Popular and trending recommendations
- Real-time search results

### **Movie Details**
- Rich movie information
- Cast and crew gallery
- User reviews and ratings
- Related movie recommendations
- YouTube trailer integration

---

## 🔧 Configuration

### **API Configuration**
```swift
// TMDBService.swift
private let baseURL = "https://api.themoviedb.org/3"
private let apiKey = "YOUR_API_KEY"
```

### **Feature Flags**
```swift
// Enable/disable features
let enableAutoSwipe = true
let enableInfiniteScroll = true
let enableTrailerWebView = true
```

---


### **Development Guidelines**
- Follow Swift style guidelines
- Write unit tests for new features
- Use RxSwift for reactive data flow
- Maintain MVVM architecture
- Add appropriate documentation

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **TMDB** - For providing the comprehensive movie database API
- **RxSwift Community** - For the excellent reactive programming framework
- **SwiftUI Team** - For the modern declarative UI framework
- **Apple** - For the amazing iOS development ecosystem

---

## 📞 Contact

**Muhammad Rydwan** - [@rydwan10](https://github.com/rydwan10)

**LinkedIn** - [Muhammad Rydwan](https://linkedin.com/in/muhammad-rydwan)

Project Link: [https://github.com/rydwan10/swiftui-alfamovie](https://github.com/rydwan10/swiftui-alfamovie)

---

<div align="center">

**Made with ❤️ and ☕ by Muhammad Rydwan**

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)](https://developer.apple.com/ios/)
[![Xcode](https://img.shields.io/badge/Xcode-15.0+-blue.svg)](https://developer.apple.com/xcode/)

</div> 
