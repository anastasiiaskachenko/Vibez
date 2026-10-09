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
    
    func saveReflection(reflection: ReflectionModel) throws {
        context.insert(reflection)
        try context.save()
    }
    
    func fetchReflectionById(byID id: UUID) throws -> ReflectionModel? {
        let descriptor = FetchDescriptor<ReflectionModel>(
            predicate: #Predicate { $0.id == id }
        )
        return try context.fetch(descriptor).first
    }
    
    func fetchReflectionsByMovieId( movieId: Int) throws -> [ReflectionModel]? {
        let descriptor = FetchDescriptor<ReflectionModel>(
            predicate: #Predicate { $0.movieId == movieId }
        )
        return try context.fetch(descriptor)
    }
    
    
    func updateReflection(byID id: UUID, newReflection: ReflectionModel) throws {
        guard let reflection = try fetchReflectionById(byID: id) else { return }
        reflection.prompt = newReflection.prompt
        reflection.content = newReflection.content
        if context.hasChanges {
            try context.save()
        }
    }
    
    
    func deleteReflection(id: UUID) throws {
        guard let reflection = try fetchReflectionById(byID: id) else { return }
        context.delete(reflection)
        try context.save()
    }
}
