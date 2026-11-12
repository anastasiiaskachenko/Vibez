import SwiftUI

struct MoviesFeedPage: View {
    let moviesState: CategoryMovieListState

    var body: some View {
        VStack {
            if moviesState.isLoading && moviesState.movies.isEmpty {
                ProgressView()
                    .frame(maxHeight: .infinity)
            } else if let errorMessage = moviesState.errorMessage,
                      moviesState.movies.isEmpty {
                ContentUnavailableView(
                    "Failed to load movies",
                    systemImage: "wifi.exclamationmark",
                    description: Text(errorMessage)
                )
            } else {
                ScrollView {
                    VStack {
                        MovieFeed(
                            movies: moviesState.movies,
                            loadMovies: { _ in
                                await moviesState.loadNextPage()
                            }
                        )
                            .padding(16)
                        if moviesState.isLoading {
                            ProgressView()
                        }
                    }
                    .padding(.bottom, 20)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            Task {

                            }
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.text)
                        }
                        .buttonStyle(.secondaryAction)
                    }
                }
            }

        }
        .background(Color.background)
        .foregroundStyle(Color.text)
        .task {
            if moviesState.movies.isEmpty {
                await moviesState.loadNextPage()
            }
        }
    }
}

#Preview {
    MoviesFilteredView(movieFilters: MovieFilters(withGenres: [28]))
}
