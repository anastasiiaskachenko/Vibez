import Foundation

protocol MovieRepositoryProtocol {
    func fetchMoviesWithFilters(page: Int, filters: MovieFilters ) async throws -> [MovieDetails]
    func fetchMoviesSearch(page: Int, query: String) async throws -> [MovieDetails]
    func fetchMovieById(id: Int) async throws -> MovieDetails
}
