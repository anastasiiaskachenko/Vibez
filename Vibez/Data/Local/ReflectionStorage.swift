import Foundation
import SwiftData

@MainActor
final class ReflectionStorage {
    private let container: ModelContainer
    private let context: ModelContext

    init(container: ModelContainer) {
        self.container = container
        self.context = container.mainContext
    }

    func createReflection(reflection: Reflection) throws {
        let reflectionModel = ReflectionModel(
            movieId: reflection.movieId,
            prompt: reflection.prompt,
            content: reflection.content,
            updatedAt: reflection.updatedAt
        )
        context.insert(reflectionModel)
        try context.save()
    }

    func fetchReflection(byID id: UUID) throws -> ReflectionModel? {
        let descriptor = FetchDescriptor<ReflectionModel>(
            predicate: #Predicate { $0.id == id }
        )
        return try context.fetch(descriptor).first
    }

    func fetchReflections(byMovieID movieId: Int) throws -> [ReflectionModel] {
        let descriptor = FetchDescriptor<ReflectionModel>(
            predicate: #Predicate { $0.movieId == movieId }
        )
        return try context.fetch(descriptor)
    }

    func updateReflection(id: UUID, newReflection: Reflection) throws {
        guard let reflection = try fetchReflection(byID: id) else { return }
        reflection.prompt = newReflection.prompt
        reflection.content = newReflection.content
        if context.hasChanges {
            try context.save()
        }
    }

    func deleteReflection(id: UUID) throws {
        guard let reflection = try fetchReflection(byID: id) else { return }
        context.delete(reflection)
        try context.save()
    }
}
