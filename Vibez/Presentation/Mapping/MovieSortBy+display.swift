extension MovieFilters.SortBy {
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
