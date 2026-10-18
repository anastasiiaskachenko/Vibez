import Foundation
import SwiftData
import Testing
@testable import Vibez

@MainActor
struct UserMovieStorageTests {
    private let testMovieId = 505
    private func makeInMemoryStorage() throws -> UserMovieStorage {
            let schema = Schema([UserMovieModel.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: schema, configurations: [config])
            return UserMovieStorage(container: container)
        }

    @Test func testGetUserMovie() throws {
        let storage = try makeInMemoryStorage()

        if try storage.getUserMovie(movieId: testMovieId) != nil {
            try storage.deleteUserMovie(movieId: testMovieId)
        }

        try storage.createUserMovie(movieId: testMovieId)

        guard let savedMovie = try storage.getUserMovie(movieId: testMovieId) else {
            print("Failed to find user movie")
            return
        }

        #expect(savedMovie.movieId == testMovieId)
    }

    @Test func testToggleIsLiked() throws {
        let storage = try makeInMemoryStorage()
        if try storage.getUserMovie(movieId: testMovieId) != nil {
            try storage.deleteUserMovie(movieId: testMovieId)
        }

        try storage.createUserMovie(movieId: testMovieId)

        guard let savedMovie = try storage.getUserMovie(movieId: testMovieId) else {
            print("Failed to find user movie")
            return
        }

        #expect(savedMovie.movieId == testMovieId)

        try storage.toggleUserMovieParam(movieId: testMovieId, param: .isLiked)

        guard let updatedMovie = try storage.getUserMovie(movieId: testMovieId) else {
            print("Failed to find user movie")
            return
        }

        #expect(updatedMovie.isLiked == true)

    }

    @Test func testDeleteUserMovie() throws {
        let storage = try makeInMemoryStorage()

        try storage.deleteUserMovie(movieId: testMovieId)

        let deletedMovie = try storage.getUserMovie(movieId: testMovieId)

        #expect(deletedMovie == nil)

    }
}
