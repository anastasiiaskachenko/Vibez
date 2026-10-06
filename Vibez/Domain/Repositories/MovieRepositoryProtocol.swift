import Foundation

protocol MovieRepositoryProtocol {
    func fetchMoviesWithFilters(page: Int, filters: MovieFilters ) async throws -> [MovieEntity]
    func fetchMoviesSearch(page: Int, query: String) async throws -> [MovieEntity]
    func fetchMovieById(id: Int) async throws -> MovieEntity
}
