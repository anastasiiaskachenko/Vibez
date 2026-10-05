import Foundation

struct MovieDetails: Codable, Identifiable, Equatable {
    var adult: Bool
    var backdropPath: String
    let id: Int
    var title: String
    var originalLanguage: String
    var originalTitle: String
    var overview: String
    var posterPath: String
    var mediaType: String
    var genreIds: [Int]
    var popularity: String
    var releaseDate: String
    var video: Bool
    var voteAvarage: Decimal
    var voteCount: Int
    
    // User interaction fields
    var isSaved: Bool = false
    var isWatched: Bool  = false
    var isLiked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id
        case title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIds = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAvarage = "vote_avarage"
        case voteCount = "vote_count"
    }
}
