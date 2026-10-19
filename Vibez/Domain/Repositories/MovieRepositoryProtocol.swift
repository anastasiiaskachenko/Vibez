import Foundation

protocol MovieRepositoryProtocol {
    func getMoviesWithFilters(page: Int, filters: MovieFilters ) async throws -> [Movie]
    func getMoviesSearch(page: Int, query: String) async throws -> [Movie]
    func getMovieById(id: Int) async throws -> Movie
}
