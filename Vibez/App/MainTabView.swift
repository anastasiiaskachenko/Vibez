import SwiftUI

struct  MainTabView: View {
    @State private var selectedTab: Tab = .discover
    @State private var previousTab: Tab = .discover
    @State private var showSearchSheet: Bool =  false

    enum Tab {
        case discover
        case searchSheet
        case watchlist
    }

    var body: some View {
        TabView(selection: Binding(
            get: { selectedTab },
            set: { newTab in
                if newTab == .searchSheet {
                    showSearchSheet = true

                    selectedTab = previousTab
                } else {
                    previousTab = newTab
                    selectedTab = newTab
                }
            }
        )) {
            NavigationStack {
                GenresView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(Tab.discover)

            Color.clear
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
                .tag(Tab.searchSheet)
            
            NavigationStack {
                WatchlistView()
            }
                .tabItem {
                    Label("Watchlist", systemImage: "bookmark")
                        .environment(\.symbolVariants, .none)
                }
                .tag(Tab.watchlist)
        }
        .sheet(isPresented: $showSearchSheet) {
            SearchView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}
