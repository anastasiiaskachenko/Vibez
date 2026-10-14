import Foundation

struct MoviesResponseDTO: Decodable {
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let totalResults: Int
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieDTO: Decodable {
    var adult: Bool
    var backdropPath: String?
    let id: Int
    var title: String
    var originalLanguage: String
    var originalTitle: String
    var overview: String
    var posterPath: String?
    var mediaType: String?
    var genreIds: [Int]?
    var genres: [GenreResponseDTO.GenreDTO]?
    var popularity: Double
    var releaseDate: String?
    var voteAverage: Double?
    var voteCount: Int?
    enum CodingKeys: String, CodingKey {
        case id, adult, title, overview, popularity
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIds = "genre_ids"
        case genres = "genres"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension MovieDTO {
    func toDomain(isSaved: Bool = true, isLiked: Bool = false, isWatched: Bool = false) -> Movie {
        let genreIds = genreIds ?? genres?.map(\.id)
        let poster = posterPath.flatMap { URL(string: AppEnvironment.tmdbPosterPath + $0)}
        let backdrop = backdropPath.flatMap { URL(string: AppEnvironment.tmdbBackdropPath + $0)}

        return Movie(
            id: self.id,
            adult: self.adult,
            backdropPath: backdrop,
            title: self.title,
            originalLanguage: self.originalLanguage,
            originalTitle: self.originalTitle,
            overview: self.overview,
            posterPath: poster,
            mediaType: self.mediaType,
            genreIds: genreIds ?? [],
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

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.timeZone = TimeZone(identifier: "Europe/Stockholm")
    formatter.locale = Locale(identifier: "sv_SE")
    return formatter
}()
