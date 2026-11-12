import SwiftUI

struct WatchlistView: View {
    @State private var viewModel: ViewModel
    @State var openFiltersPanel: Bool = false

    init(repository: MovieRepositoryProtocol = Dependencies.shared.repository) {
        _viewModel = State(wrappedValue: ViewModel(repository: repository))
    }

    var body: some View {
        VStack {
            HStack {
                Text("Watchlist")
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
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
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            ScrollView {
                VStack(spacing: 0) {
                    MovieListHorizontal(
                        movies: viewModel.moviesSaved.movies,
                        listTitle: "Want to see",
                        navTitle: "View list",
                        listDestination: MoviesFeedPage(
                            moviesState: viewModel.moviesSaved
                        ),
                        onToggleProp: viewModel.toggleProp
                    )

                    MovieListHorizontal(
                        movies: viewModel.moviesWatched.movies,
                        listTitle: "Already saw",
                        navTitle: "View history",
                        listDestination: MoviesFeedPage(moviesState: viewModel.moviesWatched),
                        onToggleProp: viewModel.toggleProp
                    )

                    MovieListHorizontal(
                        movies: viewModel.moviesLiked.movies,
                        listTitle: "Liked",
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
            }
        }
    }
}


#Preview {
        WatchlistView(repository: MockMovieRepository())
}
