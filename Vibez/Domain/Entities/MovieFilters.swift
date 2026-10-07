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
        case .popularityAsc: "Least popular"
        case .popularityDesc: "Most popular"
        case .primaryReleaseDateAsc: "Release date(Newest)"
        case .primaryReleaseDateDesc: "Release date(Oldest)"
        case .voteAverageAsc: "Highest rated"
        case .voteAverageDesc: "Lowest rated"
        }
    }
}

struct MovieFilters: Codable, Equatable {
    var includeAdult: Bool?
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
    
    func toQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        if let includeAdult {items.append(URLQueryItem(name: "include_adult", value: String(includeAdult))) }
        if let language {items.append(URLQueryItem(name: "language", value: language))}
        if let region {items.append(URLQueryItem(name: "region", value: region))}
        if let sortBy {items.append(URLQueryItem(name: "sort_by", value: sortBy.rawValue))}
        if let voteAverageGte {items.append(URLQueryItem(name: "vote_average.gte", value: String(voteAverageGte)))}
        if let voteAverageLte {items.append(URLQueryItem(name: "vote_average.lte", value: String(voteAverageLte)))}
        if let withGenres, !withGenres.isEmpty{
            let genresString = withGenres.map(String.init).joined(separator: ",")
            items.append(URLQueryItem(name: "with_genres", value: genresString))
        }
        if let withOriginCountry {items.append(URLQueryItem(name: "with_origin_country", value: withOriginCountry))}
        if let withOriginalLanguage {items.append(URLQueryItem(name: "with_original_language", value: withOriginalLanguage))}
        if let year {items.append(URLQueryItem(name: "year", value: String(year)))}
        return items
    }
}
