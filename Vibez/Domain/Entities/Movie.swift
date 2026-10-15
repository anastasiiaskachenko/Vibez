import Foundation

struct Movie: Identifiable, Equatable {
    let id: Int
    let adult: Bool
    let backdropPath: URL?
    let title: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let posterPath: URL?
    let mediaType: String?
    let genreIds: [Int]
    let popularity: Double
    let releaseDate: Date?
    let voteAverage: Double?
    let voteCount: Int?
    // User interaction fields
    var isSaved: Bool = false
    var isWatched: Bool  = false
    var isLiked: Bool = false
}
