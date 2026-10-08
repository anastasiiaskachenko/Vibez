import Foundation
import SwiftData

@MainActor
func testSwiftDataDiskStorage() throws {
    let container = try ModelContainer(for: UserMovieModel.self)
    let storage = LocalMovieStorage(container: container)
    
    let testMovieId = 505
    
    if let existing = try storage.fetchUserMovie(byID: testMovieId) {
        try storage.deleteUserMovie(movieId: testMovieId)
    }
    
    try storage.saveUserMovie(movieId: testMovieId)
    print("Movie saved successfully")
    
    guard let savedMovie = try storage.fetchUserMovie(byID: testMovieId) else {
        print("Failed to find user movie")
        return
    }
    
    print("Read from disk saved \(savedMovie.movieId), isLiked: \(savedMovie.liked)")
    
    try storage.toggleUserMovieIsLiked(movieId: testMovieId)
    
    guard let updatedMovie = try storage.fetchUserMovie(byID: testMovieId) else {
        print("Failed to find user movie")
        return
    }
    
    print("Read from disk updated \(updatedMovie.movieId), isLiked: \(updatedMovie.liked)")
    
    try storage.deleteUserMovie(movieId: testMovieId)
    
    print("user movie deleted")
    
}


