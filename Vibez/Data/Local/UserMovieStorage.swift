import Foundation
import SwiftData

enum UserMovieToggleParam {
    case isLiked
    case isSaved
    case isWatched
}

@MainActor
final class UserMovieStorage {
    private let container: ModelContainer
    private let context: ModelContext

    init(container: ModelContainer) {
        self.container = container
        self.context = container.mainContext
    }

    func createUserMovie(movieId: Int, isLiked: Bool = false, isWatched: Bool = false, isSaved: Bool = false) throws {
        context.insert(UserMovieModel(movieId: movieId))
        try context.save()
    }

    func getUserMovie(movieId: Int) throws -> UserMovieModel? {
        let descriptor = FetchDescriptor<UserMovieModel>(
            predicate: #Predicate { $0.movieId == movieId }
        )
        return try context.fetch(descriptor).first
    }

    func toggleUserMovieParam(movieId: Int, param: UserMovieToggleParam) throws {
        var userMovie: UserMovieModel
        
        if let existing = try getUserMovie(movieId: movieId) {
            userMovie = existing
        } else {
            let newModel = UserMovieModel(movieId: movieId)
            context.insert(newModel)
            userMovie = newModel
        }
        
        switch param {
        case .isLiked:
            userMovie.isLiked.toggle()
        case .isSaved:
            userMovie.isSaved.toggle()
        case .isWatched:
            userMovie.isWatched.toggle()
        }
        try context.save()
    }

    func deleteUserMovie(movieId: Int) throws {
        guard let userMovie = try getUserMovie(movieId: movieId) else { return }
        context.delete(userMovie)
        try context.save()
    }
}
