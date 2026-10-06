import Foundation

protocol GenreRepositoryProtocol {
    func fetchGenres() async throws -> [Genre]
}
