import Foundation

struct MockMovieRepository: MovieRepositoryProtocol {
    func getGenres() async throws -> [Genre] {
        return [Genre(id: 28, name: "Action")]
    }

    func getMoviesFilter(filters: MovieFilters, page: Int) async throws -> MoviesPage {
        return MoviesPage(movies: [Movie.mock], isLastPage: true)
    }

    func getMoviesSearch(query: String, page: Int) async throws -> [Movie] {
        return [Movie.mock]
    }

    func getMovieById(movieId: Int) async throws -> Movie {
        return Movie.mock
    }

    func toggleMovieIsSaved(id: Int) throws {}

    func toggleMovieIsWatched(id: Int) throws {}

    func toggleMovieIsLiked(id: Int) throws {}

    func fetchReflections(byMovieID: Int) throws -> [Reflection] {
        return [Reflection(movieId: Movie.mock.id, prompt: "Prompt text", content: "Reflection content", updatedAt: Date.now)]
    }

    func fetchReflection(byID: UUID) throws -> Reflection? {
        return Reflection(movieId: Movie.mock.id, prompt: "Prompt text", content: "Reflection content", updatedAt: Date.now)
    }

    func updateReflection(id: UUID, newReflection: Reflection) throws {}

    func deleteReflection(id: UUID) throws {}

    func fetchMoviesByInteraction(prop: UserMovieToggleParam, offset: Int) async throws -> [Movie] {
        return [Movie.mock]
    }

    func fetchMoviesByInteractionsCount(byInteractions: UserMovieToggleParam) throws -> Int {
        return 5
    }
}
