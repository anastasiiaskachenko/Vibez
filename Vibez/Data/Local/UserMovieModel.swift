import Foundation
import SwiftData

@Model
final class UserMovieModel: Identifiable {
    @Attribute(.unique) var movieId: Int
    var liked: Bool
    var saved: Bool
    var watched: Bool

    init(movieId: Int, liked: Bool, saved: Bool, watched: Bool) {
        self.movieId = movieId
        self.liked = liked
        self.saved = saved
        self.watched = watched
    }
}
