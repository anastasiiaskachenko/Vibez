import Foundation

struct MovieEntity: Identifiable, Equatable {
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

extension MovieDTO {
    func toEntity(isSaved: Bool = true, isLiked: Bool = false, isWatched: Bool = false) -> MovieEntity {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let poster = posterPath.flatMap{ URL(string: "https://image.tmdb.org/t/p/w500\($0)")}
        let backdrop = backdropPath.flatMap{ URL(string: "https://image.tmdb.org/t/p/w780\($0)")}
        
        return MovieEntity(
            id: self.id,
            adult: self.adult,
            backdropPath: backdrop,
            title: self.title,
            originalLanguage: self.originalLanguage,
            originalTitle: self.originalTitle,
            overview: self.overview,
            posterPath: poster,
            mediaType: self.mediaType,
            genreIds: self.genreIds,
            popularity: self.popularity,
            releaseDate: releaseDate.flatMap { dateFormatter.date(from: $0) },
            voteAverage: self.voteAverage,
            voteCount: self.voteCount,
            isSaved: isSaved,
            isWatched: isWatched,
            isLiked: isLiked
            
        )
    }
}
