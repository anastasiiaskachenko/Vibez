import Foundation
import SwiftData
import Testing
@testable import Vibez

@MainActor

struct UserMovieStorageTests {
    private func makeInMemoryStorage() throws -> LocalUserMovieStorage {
            let schema = Schema([UserMovieModel.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: schema, configurations: [config])
            return LocalUserMovieStorage(container: container)
        }
        
    @Test func testUsingUserMovieStorage () throws {
        let storage = try makeInMemoryStorage()
        let testMovieId = 505
        
        if let _  = try storage.fetchUserMovie(byID: testMovieId) {
            try storage.deleteUserMovie(movieId: testMovieId)
        }
        
        
        try storage.saveUserMovie(movieId: testMovieId)
        print("Movie saved successfully")
        
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
        
        try storage.deleteUserMovie(movieId: testMovieId)
        
        let deletedMovie = try storage.fetchUserMovie(byID: testMovieId)
        
        #expect(deletedMovie == nil)
        
    }
}
