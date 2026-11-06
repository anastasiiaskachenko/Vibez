extension MovieFilters.MovieCountry {
    var displayName: String {
        switch self {
        case .all: return "All Regions"
        case .unitedStates: return "United States"
        case .sweden: return "Sweden"
        case .unitedKingdom: return "United Kingdom"
        case .france: return "France"
        case .germany: return "Germany"
        case .japan: return "Japan"
        case .southKorea: return "South Korea"
        case .canada: return "Canada"
        case .spain: return "Spain"
        }
    }
}
