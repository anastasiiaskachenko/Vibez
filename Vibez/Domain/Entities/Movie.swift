import Foundation

struct Movie: Identifiable, Equatable {
    let id: Int
    var adult: Bool
    var backdropPath: URL?
    var title: String
    var originalLanguage: String
    var originalTitle: String
    var overview: String
    var posterPath: URL?
    var mediaType: String?
    var genreIds: [Int]
    var popularity: Double
    var releaseDate: Date?
    var voteAverage: Decimal?
    var voteCount: Int?
    
    // User interaction fields
    var isSaved: Bool = false
    var isWatched: Bool  = false
    var isLiked: Bool = false
}
