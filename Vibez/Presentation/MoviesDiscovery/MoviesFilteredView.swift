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
            } else if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView(
                    "Failed to load movies",
                    systemImage: "wifi.exclamationmark",
                    description: Text(errorMessage)
                )
            } else {
                ScrollView {
                    MovieFeed(movies: viewModel.movies, loadMore: viewModel.loadMovies)
                }
            }


        }
        .task {
            await viewModel.loadMovies()
        }
    }
}
