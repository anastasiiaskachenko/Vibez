import Foundation


enum SortBy: String, Codable,CaseIterable {
    case popularityAsc = "popularity.asc"
    case popularityDesc = "popularity.desc"
    case primaryReleaseDateAsc = "primary_release_date.asc"
    case primaryReleaseDateDesc = "primary_release_date.desc"
    case voteAverageAsc = "vote_average.asc"
    case voteAverageDesc = "vote_average.desc"
    
    var displayName: String {
        switch self {
        case .popularityAsc: "Most popular"
        case .popularityDesc: "Least popular"
        case .primaryReleaseDateAsc: "Release date(Newest)"
        case .primaryReleaseDateDesc: "Release date(Oldest)"
        case .voteAverageAsc: "Highest rated"
        case .voteAverageDesc: "Lowest rated"
        }
    }
}

struct MovieFilters: Codable, Equatable {
    var includeAdult: Bool?
    var includeVideo: Bool?
    var language: String?
    var region:  String?
    var sortBy: SortBy?
    var voteAverageGte: Double?
    var voteAverageLte: Double?
    var withGenres: [Int]?
    var withOriginCountry: String?
    var withOriginalLanguage: String?
    var year: Int?
    
    init(includeAdult: Bool? = nil, includeVideo: Bool? = nil, language: String? = nil, region: String? = nil, sortBy: SortBy? = nil, voteAverageGte: Double? = nil, voteAverageLte: Double? = nil, withGenres: [Int]? = nil, withOriginCountry: String? = nil, withOriginalLanguage: String? = nil, year: Int? = nil) {
        self.includeAdult = includeAdult
        self.includeVideo = includeVideo
        self.language = language
        self.region = region
        self.sortBy = sortBy
        self.voteAverageGte = voteAverageGte
        self.voteAverageLte = voteAverageLte
        self.withGenres = withGenres
        self.withOriginCountry = withOriginCountry
        self.withOriginalLanguage = withOriginalLanguage
        self.year = year
    }
    
    
    enum CodingKeys: String, CodingKey {
        case includeAdult = "include_adult"
        case includeVideo = "include_video"
        case language
        case region
        case sortBy = "sort_by"
        case voteAverageGte = "vote_average.gte"
        case voteAverageLte = "vote_average.lte"
        case withGenres = "with_genres"
        case withOriginCountry = "with_origin_country"
        case withOriginalLanguage = "with_original_language"
        case year
    }
}
