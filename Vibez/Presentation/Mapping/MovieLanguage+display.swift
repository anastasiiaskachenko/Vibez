extension MovieFilters.MovieLanguage {
    var displayName: String {
        switch self {
        case .all: return "All Languages"
        case .english: return "English"
        case .swedish: return "Swedish"
        case .spanish: return "Spanish"
        case .french: return "French"
        case .german: return "German"
        case .italian: return "Italian"
        case .japanese: return "Japanese"
        case .korean: return "Korean"
        case .chinese: return "Chinese"
        case .hindi: return "Hindi"
        }
    }
}
