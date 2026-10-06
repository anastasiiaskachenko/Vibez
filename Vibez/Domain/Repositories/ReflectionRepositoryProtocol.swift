import Foundation

protocol ReflectionRepositoryProtocol {
    func fetchReflectionsById(id: UUID) async throws -> [Reflection]
    func createReflection(reflection: Reflection) async throws -> Reflection
    func updateReflection(refleciton: Reflection) async throws -> Reflection
    func deleteReflection(id: UUID) async throws
}
