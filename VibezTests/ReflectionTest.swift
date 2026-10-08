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
        print("Reflection 1 and 2 saved successfully")
        
        guard let savedReflectionsByMovie = try storage.fetchReflectionsByMovieId(movieId: testMovieId),
              let _ = savedReflectionsByMovie.first else {
            print("No reflections found for movie id")
            return
        }
        
        print("Read from disk saved 1 \(savedReflectionsByMovie[0].prompt), answer: \(savedReflectionsByMovie[0].content)")
        print("Read from disk saved 2 \(savedReflectionsByMovie[1].prompt), answer: \(savedReflectionsByMovie[1].content)")
        
        try storage.updateReflection(byID: savedReflectionsByMovie[0].id, newReflection: ReflectionModel(movieId: testMovieId, prompt: "What did you learn from this movie", content: "Frogs are green, but sometimes yellow", createdAt: Date.now))
        
        guard let updatedReflection = try storage.fetchReflectionById(byID: savedReflectionsByMovie[0].id) else {
            print("Failed to find updated movie review")
            return
        }
        
        print("Read from disk updated \(updatedReflection.prompt), answer: \(updatedReflection.content)")
        
        try storage.deleteReflection(id: updatedReflection.id)
        
        print("Reflection deleted")

    }
}
