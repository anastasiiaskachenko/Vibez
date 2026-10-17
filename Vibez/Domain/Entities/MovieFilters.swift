
struct MovieFilters: Codable, Equatable {
    var includeAdult: Bool?
    var language: String?
    var region: String?
    var sortBy: SortBy?
    var voteAverageGte: Double?
    var voteAverageLte: Double?
    var withGenres: [Int]?
    var withOriginCountry: String?
    var withOriginalLanguage: String?
    var year: Int?
    
    init(
        includeAdult: Bool? = nil,
        language: String? = nil,
        region: String? = nil,
        sortBy: SortBy? = nil,
        voteAverageGte: Double? = nil,
        voteAverageLte: Double? = nil,
        withGenres: [Int]? = nil,
        withOriginCountry: String? = nil,
        withOriginalLanguage: String? = nil,
        year: Int? = nil
    ) {
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
}
