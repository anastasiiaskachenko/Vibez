import SwiftUI

struct MoviesFilteredView: View {
    @State private var viewModel: ViewModel

    init(repository: MovieRepositoryProtocol = Dependencies.shared.repository, movieFilters: MovieFilters?) {
        _viewModel = State(wrappedValue: ViewModel(repository: repository, movieFilters: movieFilters))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.movies.isEmpty {
                ProgressView()
                    .frame(maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage,
                      viewModel.movies.isEmpty {
                ContentUnavailableView(
                    "Failed to load movies",
                    systemImage: "wifi.exclamationmark",
                    description: Text(errorMessage)
                )
            } else {
                ScrollView {
                    VStack {
                        if let heroMovie = viewModel.movies.first { MoviesFilteredHero(movie: heroMovie)
                        }

                        MovieFeed(movies: Array(viewModel.movies.dropFirst()), loadMore: viewModel.loadMovies)
                        if viewModel.isLoading {
                            ProgressView()
                        } else if viewModel.isLastPage {
                            Text("You reached the end of the list.")
                        } else if viewModel.errorMessage != nil {
                            Button {
                                Task {
                                    await viewModel.loadMovies()
                                }
                            } label: {
                                Text("Failed to load movies. Press here to retry.")
                                .padding(12)
                                .background(Color.accent)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
                .ignoresSafeArea(edges: .top)
            }

        }
        .background(Color.background)
        .foregroundStyle(Color.text)
        .task {
            if viewModel.movies.isEmpty {
                await viewModel.loadMovies()
            }
        }
    }
}

#Preview {
    MoviesFilteredView(movieFilters: MovieFilters(withGenres: [28]))
}
