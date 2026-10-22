import Foundation

extension MovieDetailsView {
    @Observable
    class ViewModel {
        let repository: MovieRepositoryProtocol
        var movieId: Int
        var movie: Movie?
        var page: Int = 0
        var isLoading: Bool = false
        var errorMessage: String?
        var isLastPage: Bool = false
        var movieFilters: MovieFilters?

        init(repository: MovieRepositoryProtocol, movieId: Int) {
            self.repository = repository
             self.movieId = movieId
        }

        func fetchMovie() async {
            isLoading = true
            defer { isLoading = false}
            do {
                let response = try await repository.getMovieById(movieId: movieId)
                self.movie = response
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }

        func toggleIsSaved() {
            guard var currentMovie = movie else { return }
            currentMovie.isSaved.toggle()
            self.movie = currentMovie
            do {
                try repository.toggleMovieIsSaved(id: currentMovie.id)
            } catch {
                errorMessage = "Failed to toggle isSaved on movie \(currentMovie.id): \(error.localizedDescription)"
            }
        }

        func toggleIsWatched() {
            guard var currentMovie = movie else { return }
            currentMovie.isWatched.toggle()
            self.movie = currentMovie
            do {
                try repository.toggleMovieIsWatched(id: currentMovie.id)
            } catch {
                errorMessage = "Failed to toggle isWatched on movie \(currentMovie.id): \(error.localizedDescription)"
            }
        }

        func toggleIsLiked() {
            print("movie var, \(movie)")
            guard var currentMovie = movie else { return }
            currentMovie.isLiked.toggle()
            self.movie = currentMovie
            do {
                try repository.toggleMovieIsLiked(id: currentMovie.id)
                print("successfully toggled is liked")
            } catch {
                print("Failed to toggle is liked on movie, \(error.localizedDescription)")
                self.errorMessage = "Failed to toggle isLiked on movie \(currentMovie.id): \(error.localizedDescription)"
            }
        }
    }
}
