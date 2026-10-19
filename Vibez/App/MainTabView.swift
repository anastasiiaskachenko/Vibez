import SwiftUI

struct  MainTabView: View {
    let repository: MovieRepositoryProtocol
    @State private var selectedTab: Tab = .discover
    
    enum Tab {
        case discover
        case watchlist
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                GenresView(repository: repository)
            }
            .tabItem {
                Label("Discover", systemImage: "magnifyingglass")
            }
            .tag(Tab.discover)
            
        }
    }
}
