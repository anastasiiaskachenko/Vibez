import SwiftUI

struct  MainTabView: View {
    @State private var selectedTab: Tab = .discover

    enum Tab {
        case discover
        case watchlist
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                GenresView()
            }
            .tabItem {
                Label("Discover", systemImage: "magnifyingglass")
            }
            .tag(Tab.discover)
        }
    }
}
