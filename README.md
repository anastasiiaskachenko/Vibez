# Vibez 🎬

**Vibez** is a modern iOS application that allows users to discover movies, manage a personal watchlist, and  reflect on characters and movie themes. 

Built with a focus on **MVVM**, and **Component-Driven UI Design**.

---

## Architecture & Strategy

Vibez follows Clean Architecture principles to enforce clear boundaries and unidirectional data flow.

- **Domain Layer:** Contains zero external dependencies. Defines core entities (`Movie`, `Reflection`) and abstract repository protocols.
- **Data Layer:** Implements API calls (TMDB REST API) and local persistence (SwiftData). Maps Data Transfer Objects (DTOs) and SwiftData `@Model` classes into pure Domain entities.
- **Presentation Layer:** Built with SwiftUI using MVVM. UI components are modular, stateless, and stateful logic is encapsulated within `@Observable` ViewModels.

---

## 📁 Project Structure

```text
Vibez/
├── Domain/
│   ├── Entities/             # Pure Swift models (Movie, Reflection)
│   └── Repositories/          # Abstract contracts (MovieRepositoryProtocol)
├── Data/
│   ├── Network/              # TMDB API Client & DTOs
│   ├── Local/                # SwiftData Models & Context management
│   └── Repositories/          # Implementations of Domain protocols
└── Presentation/
    ├── Components/           # Reusable UI components (MovieCard, StateView)
    ├── Discovery/            # Movie browsing & search screens
    ├── Watchlist/            # Saved movies flow
    └── Reflections/          # Writing & reading character reflections
```

## Tech Stack
- Language: Swift 5.10 / Swift 6
- UI Framework: SwiftUI
- Persistence: SwiftData
- Networking: URLSession with Async/Await
 -Architecture: MVVM + Clean Architecture + Dependency Injection


## Getting Started

1. Clone the repository
```
Bash

git clone https://github.com/your-username/vibez-ios.git
```
2. Configure API Keys
- Create an account on The Movie Database (TMDB).
- Obtain a Read Access Token / API Key.
- Add your key to Secrets.plist (or environment configuration).

# Build & Run

Open Vibez.xcodeproj in Xcode 15.4+ or Xcode 16.
Target iOS 17.0+.
  
