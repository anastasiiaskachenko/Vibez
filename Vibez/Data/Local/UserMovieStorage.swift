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

    func fetchUserMovie(byMovieID movieId: Int) throws -> UserMovieModel? {
        let descriptor = FetchDescriptor<UserMovieModel>(
            predicate: #Predicate { $0.movieId == movieId }
        )
        return try context.fetch(descriptor).first
    }

    func fetchUserMovies(
            byInteractions prop: UserMovieToggleParam,
            limit: Int = 20,
            offset: Int = 0
    ) throws -> [UserMovieModel] {
        var predicate: Predicate<UserMovieModel>
        switch prop {
            case .isLiked:
                predicate = #Predicate<UserMovieModel> { $0.isLiked == true}
            case .isWatched:
                predicate = #Predicate<UserMovieModel> { $0.isWatched == true}
            case .isSaved:
                predicate = #Predicate<UserMovieModel> { $0.isSaved == true}
        }

        var descriptor = FetchDescriptor<UserMovieModel>(
            predicate: predicate
        )

        descriptor.fetchLimit = limit
        descriptor.fetchOffset = offset
        return try context.fetch(descriptor)
    }


    func toggleUserMovieParam(movieId: Int, param: UserMovieToggleParam) throws {
        var userMovie: UserMovieModel

        if let existing = try fetchUserMovie(byMovieID: movieId) {
            userMovie = existing
        } else {
            let newModel = UserMovieModel(movieId: movieId)
            context.insert(newModel)
            userMovie = newModel
        }

        switch param {
        case .isLiked:
            userMovie.isLiked.toggle()
            userMovie.isSaved = false
        case .isSaved:
            userMovie.isSaved.toggle()
        case .isWatched:
            userMovie.isWatched.toggle()
            userMovie.isSaved = false
        }
        try context.save()

        NotificationCenter.default.post(name: .userMovieDidUpdate, object: nil)
    }

    func deleteUserMovie(movieId: Int) throws {
        guard let userMovie = try fetchUserMovie(byMovieID: movieId) else { return }
        context.delete(userMovie)
        try context.save()
    }
}

extension Notification.Name {
    static let userMovieDidUpdate = Notification.Name("UserMovieDidUpdate")
}
