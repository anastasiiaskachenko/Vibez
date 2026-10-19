import Foundation
import SwiftData
import Testing
@testable import Vibez

@MainActor
struct UserMovieStorageTests {
    private let testMovieId = 505

    @Test func testGetUserMovie() throws {
        let storage = makeContainer(inMemory: true).userMovieStore

        if try storage.fetchUserMovie(byMovieID: testMovieId) != nil {
            try storage.deleteUserMovie(movieId: testMovieId)
        }

        try storage.createUserMovie(movieId: testMovieId)

        guard let savedMovie = try storage.fetchUserMovie(byMovieID: testMovieId) else {
            print("Failed to find user movie")
            return
        }

        #expect(savedMovie.movieId == testMovieId)
    }

    @Test func testToggleIsLiked() throws {
        let storage = makeContainer(inMemory: true).userMovieStore
        if try storage.fetchUserMovie(byMovieID: testMovieId) != nil {
            try storage.deleteUserMovie(movieId: testMovieId)
        }

        try storage.createUserMovie(movieId: testMovieId)

        guard let savedMovie = try storage.fetchUserMovie(byMovieID: testMovieId) else {
            print("Failed to find user movie")
            return
        }

        #expect(savedMovie.movieId == testMovieId)

        try storage.toggleUserMovieParam(movieId: testMovieId, param: .isLiked)

        guard let updatedMovie = try storage.fetchUserMovie(byMovieID: testMovieId) else {
            print("Failed to find user movie")
            return
        }

        #expect(updatedMovie.isLiked == true)

    }

    @Test func testDeleteUserMovie() throws {
        let storage = makeContainer(inMemory: true).userMovieStore

        try storage.deleteUserMovie(movieId: testMovieId)

        let deletedMovie = try storage.fetchUserMovie(byMovieID: testMovieId)

        #expect(deletedMovie == nil)

    }
}
