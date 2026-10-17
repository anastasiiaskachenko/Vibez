enum SortBy: String, Codable, CaseIterable {
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
        case .primaryReleaseDateAsc: "Release date(Oldest)"
        case .primaryReleaseDateDesc: "Release date(Newest)"
        case .voteAverageAsc: "Lowest rated"
        case .voteAverageDesc: "Highest rated"
        }
    }
}
