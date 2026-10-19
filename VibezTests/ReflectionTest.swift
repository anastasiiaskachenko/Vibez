import Foundation
import SwiftData
import Testing
@testable import Vibez

@MainActor

struct ReflectionStorageTests {
    private let testMovieId = 505
    private func makeInMemoryStorage() throws -> ReflectionStorage {
        let schema = Schema([ReflectionModel.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        return ReflectionStorage(container: container)
    }

    @Test func testSavingReflection() throws {
        let storage = try makeInMemoryStorage()

        try storage.createReflection(reflection:
                                    Reflection(
                                        movieId: testMovieId,
                                        prompt: "What did you learn from this movie",
                                        content: "Frogs are green",
                                        updatedAt: Date.now
                                    ))
        let savedReflectionsByMovie = try storage.fetchReflections(byMovieID: testMovieId)

        #expect(savedReflectionsByMovie[0].movieId == testMovieId)
    }

    @Test func testSaveMultipleReflectionsPerMovie() throws {
        let storage = try makeInMemoryStorage()

        try storage.createReflection(reflection:
                                    Reflection(
                                        movieId: testMovieId,
                                        prompt: "What did you learn from this movie",
                                        content: "Frogs are green",
                                        updatedAt: Date.now
                                    ))

        try storage.createReflection(reflection:
                                    Reflection(
                                        movieId: testMovieId,
                                        prompt: "Who did you like the most",
                                        content: "Main characters cat",
                                        updatedAt: Date.now
                                    ))

        let savedReflectionsByMovie = try storage.fetchReflections(byMovieID: testMovieId)

        #expect(savedReflectionsByMovie.count == 2)
    }

    @Test func testUpdateReflection() throws {
        let storage = try makeInMemoryStorage()
        try storage.createReflection(reflection:
                                    Reflection(
                                        movieId: testMovieId,
                                        prompt: "What did you learn from this movie",
                                        content: "Frogs are green",
                                        updatedAt: Date.now
                                    ))
        let savedReflectionsByMovie = try storage.fetchReflections(byMovieID: testMovieId)

        try storage.updateReflection(id: savedReflectionsByMovie[0].id, newReflection:
                                        Reflection(
                                            movieId: testMovieId,
                                            prompt: "What did you learn from this movie",
                                            content: "Frogs are green, but sometimes yellow",
                                            updatedAt: Date.now
                                        ))

        guard let updatedReflection = try storage.fetchReflection(byID: savedReflectionsByMovie[0].id) else {
            print("Failed to find updated movie review")
            return
        }

        #expect(updatedReflection.content == "Frogs are green, but sometimes yellow")
    }

    @Test func testDeleteReflection() throws {
        let storage = try makeInMemoryStorage()
        try storage.createReflection(reflection:
                                    Reflection(
                                        movieId: testMovieId,
                                        prompt: "What did you learn from this movie",
                                        content: "Frogs are green",
                                        updatedAt: Date.now
                                    ))
        let savedReflectionsByMovie = try storage.fetchReflections(byMovieID: testMovieId)
        try storage.deleteReflection(id: savedReflectionsByMovie[0].id)

        let deletedReflection = try storage.fetchReflection(byID: savedReflectionsByMovie[0].id)

        #expect(deletedReflection == nil)
    }
}
