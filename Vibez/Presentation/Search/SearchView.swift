import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ViewModel
    @State var searchQuery: String = ""
    @FocusState private var isFocused: Bool

    init(
        repository: MovieRepositoryProtocol = Dependencies.shared.repository
    ) {
        _viewModel = State(
            initialValue: ViewModel(
                repository: repository
            )
        )
    }

    var body: some View {
        NavigationStack {
            VStack {
                MovieSuggestionsFeed(
                    isLoading: viewModel.isLoading,
                    errorMessage: viewModel.errorMessage,
                    movies: viewModel.suggestionMovies,
                    onDismissKeyBoard: {
                        if isFocused {
                            isFocused = false
                        }
                    }
                )
                MovieSearchBar(
                    searchQuery: $searchQuery,
                    onQueryChange: viewModel.onChange,
                    isFocused: $isFocused)
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 14)
            .toolbarBackground(Color.background, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Suggestions")
                        .font(.title)
                }
            }
            .background(Color.background)
            .foregroundStyle(Color.text)
            .task {
                if searchQuery == "" || viewModel.suggestionMovies.isEmpty {
                    await viewModel.loadDefaultMovies()
                }
            }
        }
    }
}
