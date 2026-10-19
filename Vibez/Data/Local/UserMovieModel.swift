import Foundation
import SwiftData

@Model
final class UserMovieModel: Identifiable {
    @Attribute(.unique) var movieId: Int
    var isLiked: Bool
    var isSaved: Bool
    var isWatched: Bool

    init(movieId: Int, isLiked: Bool = false, isSaved: Bool = false, isWatched: Bool = false) {
        self.movieId = movieId
        self.isLiked = isLiked
        self.isSaved = isSaved
        self.isWatched = isWatched
    }
}
