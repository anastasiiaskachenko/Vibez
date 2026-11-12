import Foundation

extension WatchlistView {
    @Observable
    class ViewModel {
        let repository: MovieRepositoryProtocol
        var moviesLiked: CategoryMovieListState
        var moviesWatched: CategoryMovieListState
        var moviesSaved: CategoryMovieListState
        var offset: Int = 0
        var errorMessage: String?

        init(repository: MovieRepositoryProtocol) {
            self.repository = repository
            self.moviesLiked = CategoryMovieListState(prop: .isLiked)
            self.moviesWatched = CategoryMovieListState(prop: .isWatched)
            self.moviesSaved = CategoryMovieListState(prop: .isSaved)
        }

        func fetchAllLists() async {
            do {
                async let saved: () = moviesSaved.loadNextPage(reset: true)
                async let watched: () = moviesWatched.loadNextPage(reset: true)
                async let liked: () = moviesLiked.loadNextPage(reset: true)
                _ = try await (saved, watched, liked)
            } catch {
                self.errorMessage = error.localizedDescription
            }

        }

        func toggleProp(_ prop: ToggleProps, movieId: Int) async {
            do {
                try prop.performToggle(on: repository, movieId: movieId)
            } catch {
                errorMessage =
                """
                    Failed to toggle \(prop) on movie
                    \(movieId): \(error.localizedDescription)
                """
            }
        }
    }
}
