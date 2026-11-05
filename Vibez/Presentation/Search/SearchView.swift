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
                if viewModel.isLoading && viewModel.suggestionMovies.isEmpty {
                    ProgressView()
                        .frame(maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage,
                         viewModel.suggestionMovies.isEmpty {
                   ContentUnavailableView(
                       "Failed to load movies",
                       systemImage: "wifi.exclamationmark",
                       description: Text(errorMessage)
                   )
               } else if viewModel.suggestionMovies.isEmpty {
                    ContentUnavailableView(
                        "No movies match your search, try different key words.",
                        systemImage: "film"
                    )
                } else {
                    ScrollView {
                        MovieFeed(movies: viewModel.suggestionMovies, loadMore: {})
                    }
                    .contentMargins(.top, 0, for: .scrollContent)
                    .simultaneousGesture(
                        DragGesture().onChanged { _ in
                            if isFocused {
                                isFocused = false
                            }
                        }
                    )
                    .scrollDismissesKeyboard(.interactively)
                }

                HStack(spacing: 8) {
                    TextField("Start typing here...", text: $searchQuery)
                        .onChange(of: searchQuery) {_, _ in
                            viewModel.onChange(query: searchQuery)
                        }
                        .focused($isFocused)
                    Button {
                        isFocused = false
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.accent)
                    }
                }
                .padding(16)
                .background(.bgSecondary)
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.bgSecondaryLight, lineWidth: 2)

                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
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
