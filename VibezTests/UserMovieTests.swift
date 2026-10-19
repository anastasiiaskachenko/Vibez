import Foundation
import SwiftData
import Testing
@testable import Vibez

@MainActor
struct UserMovieStorageTests {
    private let testMovieId = 505

    @Test func testGetUserMovie() throws {
        let storage = try makeContainer(inMemory: true).userMovieStore

        if try storage.fetchUserMovie(byID: testMovieId) != nil {
            try storage.deleteUserMovie(movieId: testMovieId)
        }

        try storage.saveUserMovie(movieId: testMovieId)

        guard let savedMovie = try storage.fetchUserMovie(byID: testMovieId) else {
            print("Failed to find user movie")
            return
        }

        #expect(savedMovie.movieId == testMovieId)
    }

    @Test func testToggleIsLiked() throws {
        let storage = try makeContainer(inMemory: true).userMovieStore
        if try storage.fetchUserMovie(byID: testMovieId) != nil {
            try storage.deleteUserMovie(movieId: testMovieId)
        }

        try storage.saveUserMovie(movieId: testMovieId)

        guard let savedMovie = try storage.fetchUserMovie(byID: testMovieId) else {
            print("Failed to find user movie")
            return
        }

        #expect(savedMovie.movieId == testMovieId)

        try storage.toggleUserMovieIsLiked(movieId: testMovieId)

        guard let updatedMovie = try storage.fetchUserMovie(byID: testMovieId) else {
            print("Failed to find user movie")
            return
        }

        #expect(updatedMovie.liked == true)

    }

    @Test func testDeleteUserMovie() throws {
        let storage = try makeContainer(inMemory: true).userMovieStore

        try storage.deleteUserMovie(movieId: testMovieId)

        let deletedMovie = try storage.fetchUserMovie(byID: testMovieId)

        #expect(deletedMovie == nil)

    }
}
