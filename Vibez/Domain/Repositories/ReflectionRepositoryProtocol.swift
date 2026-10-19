import Foundation

protocol ReflectionRepositoryProtocol {
    func fetchReflectionsByMovieId(movieId: Int) async throws -> [Reflection]
    func createReflection(reflection: Reflection) async throws -> Reflection
    func updateReflection(reflection: Reflection) async throws -> Reflection
    func deleteReflection(id: UUID) async throws
}
