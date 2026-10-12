import Foundation
import SwiftData


@MainActor
final class LocalUserMovieStorage {
    private let container: ModelContainer
    private let context: ModelContext
    
    init(container: ModelContainer) {
        self.container = container
        self.context = container.mainContext
    }
    
    func saveUserMovie(movieId: Int, isLiked: Bool = false, isWatched: Bool = false, isSaved: Bool = true) throws {
        context.insert(UserMovieModel(movieId: movieId, liked: isLiked, saved: isSaved, watched: isWatched))
        try context.save()
    }
    
    func fetchUserMovie(byID movieId: Int) throws -> UserMovieModel? {
        let descriptor = FetchDescriptor<UserMovieModel>(
            predicate: #Predicate { $0.movieId == movieId }
        )
        return try context.fetch(descriptor).first
    }
    
    
    func toggleUserMovieIsLiked(movieId: Int) throws {
        guard let userMovie = try fetchUserMovie(byID: movieId) else { return }
        userMovie.liked.toggle()
        try context.save()
    }
    
    func toggleUserMovieIsWatched(movieId: Int) throws {
        guard let userMovie = try fetchUserMovie(byID: movieId) else { return }
        userMovie.watched.toggle()
        try context.save()
    }
    
    func toggleUserMovieIsSaved(movieId: Int) throws {
        guard let userMovie = try fetchUserMovie(byID: movieId) else { return }
        userMovie.saved.toggle()
        try context.save()
    }
    
    func deleteUserMovie(movieId: Int) throws {
        guard let userMovie = try fetchUserMovie(byID: movieId) else { return }
        context.delete(userMovie)
        try context.save()
    }
}
