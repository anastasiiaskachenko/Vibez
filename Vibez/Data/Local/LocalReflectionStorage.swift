import Foundation
import SwiftData


@MainActor
struct ReflectionStorage {
    private let container: ModelContainer
    private let context: ModelContext
    
    init(container: ModelContainer) {
        self.container = container
        self.context = container.mainContext
    }
    
    func saveReflection(reflection: Reflection) throws {
        context.insert(ReflectionModel(
            movieId: reflection.movieId, prompt: reflection.prompt, content: reflection.content, createdAt: reflection.createdAt
        ))
        try context.save()
    }
    
    func fetchReflectionById(byID id: UUID) throws -> Reflection? {
        let descriptor = FetchDescriptor<ReflectionModel>(
            predicate: #Predicate { $0.id == id }
        )
        guard let reflectionModel = try context.fetch(descriptor).first else {
            return nil
        }
        
        return Reflection(movieId: reflectionModel.movieId, content: reflectionModel.content, createdAt: reflectionModel.createdAt)
    }
    
    func fetchReflectionsByMovieId( movieId: Int) throws -> [Reflection] {
        let descriptor = FetchDescriptor<ReflectionModel>(
            predicate: #Predicate { $0.movieId == movieId }
        )
        
        let reflectionsModel = try context.fetch(descriptor)
        return reflectionsModel.map {model in
            Reflection(
                id: model.id,
                movieId: model.movieId,
                content: model.content,
                createdAt: model.createdAt
            )
        }
    }
    
    
    func updateReflection(byID id: UUID, newReflection: Reflection) throws {
        guard var reflection = try fetchReflectionById(byID: id) else { return }
        reflection.prompt = newReflection.prompt
        reflection.content = newReflection.content
        if context.hasChanges {
            try context.save()
        }
    }
    
    
    func deleteReflection(id: UUID) throws {
        let descriptor = FetchDescriptor<ReflectionModel>(
            predicate: #Predicate { $0.id == id }
        )
        guard let reflection = try context.fetch(descriptor).first else { return }
        context.delete(reflection)
        try context.save()
    }
}
