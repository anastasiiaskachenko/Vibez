import Foundation

extension MovieDetailsView {
    @Observable
    class ViewModel {
        let repository: MovieRepositoryProtocol
        var movie: Movie
        var page: Int = 0
        var isLoading: Bool = false
        var errorMessage: String?
        var isLastPage: Bool = false
        var movieFilters: MovieFilters?

        init(repository: MovieRepositoryProtocol, movie: Movie) {
            self.repository = repository
             self.movie = movie
        }

        func toggleIsSaved() {
            do {
                try repository.toggleMovieIsSaved(id: movie.id)
            } catch {
                errorMessage = "Failed to toggle isSaved on movie \(movie.id): \(error.localizedDescription)"
            }
        }

        func toggleIsWatched() {
            do {
                try repository.toggleMovieIsWatched(id: movie.id)
            } catch {
                errorMessage = "Failed to toggle isWatched on movie \(movie.id): \(error.localizedDescription)"
            }
        }

        func toggleIsLiked() {
            do {
                try repository.toggleMovieIsLiked(id: movie.id)
            } catch {
                errorMessage = "Failed to toggle isLiked on movie \(movie.id): \(error.localizedDescription)"
            }
        }


    }
}
