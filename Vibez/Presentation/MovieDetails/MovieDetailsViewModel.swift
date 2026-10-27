import Foundation

extension MovieDetailsView {
    enum ToggleProps {
        case isLiked
        case isSaved
        case isWatched

        var keyPath: WritableKeyPath<Movie, Bool> {
            switch self {
            case .isLiked: return \.isLiked
            case .isSaved: return \.isSaved
            case .isWatched: return \.isWatched
            }
        }

        func performToggle(
            on repository: MovieRepositoryProtocol,
            movieId: Int
        ) throws {
            switch self {
            case .isLiked:
                try repository.toggleMovieIsLiked(id: movieId)
            case .isSaved:
                try repository.toggleMovieIsSaved(id: movieId)
            case .isWatched:
                try repository.toggleMovieIsWatched(id: movieId)
            }
        }
    }
    
    @Observable
    class ViewModel {
        let repository: MovieRepositoryProtocol
        let movieId: Int
        var movie: Movie?
        var isLoading: Bool = false
        var errorMessage: String?

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

        func toggleProp(_ prop: ToggleProps) async {
            guard var currentMovie = movie else { return }
            currentMovie[keyPath: prop.keyPath].toggle()
            self.movie = currentMovie
            do {
                try prop.performToggle(on: repository, movieId: currentMovie.id)
            } catch {
                currentMovie[keyPath: prop.keyPath].toggle()
                self.movie = currentMovie
                errorMessage =
                """
                    Failed to toggle \(prop) on movie
                    \(currentMovie.id): \(error.localizedDescription)
                """
            }
        }
    }
}
