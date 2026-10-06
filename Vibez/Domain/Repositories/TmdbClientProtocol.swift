import Foundation

protocol TmdbClientProtocol {
    func fetchGenres() async throws -> [Genre]
    func fetchMoviesWithFilters(page: Int, filters: MovieFilters ) async throws -> [MovieDTO]
    func fetchMoviesSearch(page: Int, query: String) async throws -> [MovieDTO]
    func fetchMovieById(id: Int) async throws -> MovieDTO
}
