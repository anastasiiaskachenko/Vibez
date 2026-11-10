struct MovieFilters: Codable, Equatable {
    var includeAdult: Bool?
    var language: MovieLanguage?
    var sortBy: SortBy?
    var voteAverageGte: Double?
    var withGenres: [Int]?
    var withOriginCountry: MovieCountry?
    var withOriginalLanguage: MovieLanguage?

    enum SortBy: String, Codable, CaseIterable, Identifiable {
        case popularityDesc = "popularity.desc"
        case popularityAsc = "popularity.asc"
        case voteAverageDesc = "vote_average.desc"
        case voteAverageAsc = "vote_average.asc"
        case primaryReleaseDateDesc = "primary_release_date.desc"
        case primaryReleaseDateAsc = "primary_release_date.asc"

        var id: String { rawValue }
    }

    enum MovieLanguage: String, Codable, CaseIterable, Identifiable {
        case all = ""
        case english = "en"
        case swedish = "sv"
        case spanish = "es"
        case french = "fr"
        case german = "de"
        case italian = "it"
        case japanese = "ja"
        case korean = "ko"
        case chinese = "zh"
        case hindi = "hi"

        var id: String { rawValue }
    }

    enum MovieCountry: String, Codable, CaseIterable, Identifiable {
        case all = ""
        case unitedStates = "US"
        case sweden = "SE"
        case unitedKingdom = "GB"
        case france = "FR"
        case germany = "DE"
        case japan = "JP"
        case southKorea = "KR"
        case canada = "CA"
        case spain = "ES"

        var id: String { rawValue }
    }
}
