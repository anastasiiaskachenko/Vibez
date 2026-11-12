import SwiftUI

struct WatchlistView: View {
    @State private var viewModel: ViewModel
    @State var openFiltersPanel: Bool = false

    init(repository: MovieRepositoryProtocol = Dependencies.shared.repository) {
        _viewModel = State(wrappedValue: ViewModel(repository: repository))
    }

    var body: some View {
        VStack {
            Text("Watchlist")
                .font(.title)
                .fontWeight(.semibold)
            .padding(.horizontal, 16)
            ScrollView {
                VStack(spacing: 0) {
                    MovieListHorizontal(
                        moviesState: viewModel.moviesSaved,
                        navTitle: "View list",
                        listDestination: MoviesFeedPage(
                            moviesState: viewModel.moviesSaved
                        ),
                        onToggleProp: viewModel.toggleProp
                    )

                    MovieListHorizontal(
                        moviesState: viewModel.moviesWatched,
                        navTitle: "View history",
                        listDestination: MoviesFeedPage(moviesState: viewModel.moviesWatched),
                        onToggleProp: viewModel.toggleProp
                    )

                    MovieListHorizontal(
                        moviesState: viewModel.moviesLiked,
                        navTitle: "View list",
                        listDestination: MoviesFeedPage(moviesState: viewModel.moviesLiked),
                        onToggleProp: viewModel.toggleProp
                    )
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .leading)
        .background(Color.background)
        .foregroundStyle(Color.text)
        .task {
            await viewModel.fetchAllLists()
        }
        .onReceive(NotificationCenter.default.publisher(for: .userMovieDidUpdate)) { _ in
            Task {
                await viewModel.fetchAllLists()
                await viewModel.moviesSaved.fetchMoviesCount()
                await viewModel.moviesWatched.fetchMoviesCount()
                await viewModel.moviesLiked.fetchMoviesCount()
            }
        }
    }
}


#Preview {
        WatchlistView(repository: MockMovieRepository())
}
