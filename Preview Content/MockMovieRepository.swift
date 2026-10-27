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

}
