import Foundation

protocol MovieRepositoryProtocol {
    func getMoviesWithFilters(page: Int, filters: MovieFilters ) async throws -> [MovieEntity]
    func getMoviesSearch(page: Int, query: String) async throws -> [MovieEntity]
    func getMovieById(id: Int) async throws -> MovieEntity
}
