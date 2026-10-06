import Foundation

struct MovieDTO: Decodable{
    var adult: Bool
    var backdropPath: String?
    let id: Int
    var title: String
    var originalLanguage: String
    var originalTitle: String
    var overview: String
    var posterPath: String?
    var mediaType: String?
    var genreIds: [Int]
    var popularity: Double
    var releaseDate: String?
    var voteAverage: Decimal?
    var voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, adult, title, overview, popularity
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case voteAverage = "vote_avarage"
        case voteCount = "vote_count"
    }
}
