// TODO: Andy please take a look at this. How is it best to handle MovieFilters 

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

    enum SortBy: String, Codable, CaseIterable {
        case popularityAsc = "popularity.asc"
        case popularityDesc = "popularity.desc"
        case primaryReleaseDateAsc = "primary_release_date.asc"
        case primaryReleaseDateDesc = "primary_release_date.desc"
        case voteAverageAsc = "vote_average.asc"
        case voteAverageDesc = "vote_average.desc"
    }
}
