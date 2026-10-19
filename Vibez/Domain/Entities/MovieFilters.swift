struct MovieFilters: Codable, Equatable {
    let includeAdult: Bool?
    let language: String?
    let region: String?
    let sortBy: SortBy?
    let voteAverageGte: Double?
    let voteAverageLte: Double?
    let withGenres: [Int]?
    let withOriginCountry: String?
    let withOriginalLanguage: String?
    let year: Int?

    enum SortBy: String, Codable, CaseIterable {
        case popularityAsc = "popularity.asc"
        case popularityDesc = "popularity.desc"
        case primaryReleaseDateAsc = "primary_release_date.asc"
        case primaryReleaseDateDesc = "primary_release_date.desc"
        case voteAverageAsc = "vote_average.asc"
        case voteAverageDesc = "vote_average.desc"
    }
}
