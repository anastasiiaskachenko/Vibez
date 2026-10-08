import Foundation
import SwiftData
import Testing
@testable import Vibez

@MainActor

struct ReflectionStorageTests {
    
    private func makeInMemoryStorage() throws -> ReflectionStorage {
        let schema = Schema([ReflectionModel.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        return ReflectionStorage(container: container)
    }
    
    @Test func testUsingReflectionStorage () throws {
        let storage = try makeInMemoryStorage()
        
        let testMovieId = 505
        
        try storage.saveReflection(reflection: ReflectionModel(movieId: testMovieId, prompt: "What did you learn from this movie", content: "Frogs are green", createdAt: Date.now))
        
        try storage.saveReflection(reflection: ReflectionModel(movieId: testMovieId, prompt: "Who did you like the most", content: "Main characters cat", createdAt: Date.now))
        
        guard let savedReflectionsByMovie = try storage.fetchReflectionsByMovieId(movieId: testMovieId),
              let _ = savedReflectionsByMovie.first else {
            print("No reflections found for movie id")
            return
        }
        #expect(savedReflectionsByMovie.count == 2)
        
        
        try storage.updateReflection(byID: savedReflectionsByMovie[0].id, newReflection: ReflectionModel(movieId: testMovieId, prompt: "What did you learn from this movie", content: "Frogs are green, but sometimes yellow", createdAt: Date.now))
        
        guard let updatedReflection = try storage.fetchReflectionById(byID: savedReflectionsByMovie[0].id) else {
            print("Failed to find updated movie review")
            return
        }
        
        #expect(updatedReflection.content == "Frogs are green, but sometimes yellow")
        
        try storage.deleteReflection(id: updatedReflection.id)
        
        let deletedReflection = try storage.fetchReflectionById(byID: savedReflectionsByMovie[0].id)
                
        #expect(deletedReflection == nil)
    }
}
