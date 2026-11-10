import Foundation

extension MovieFilters {
    func toQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let includeAdult {items.append(URLQueryItem(name: "include_adult", value: String(includeAdult))) }
        if let language, language != .all {items.append(URLQueryItem(name: "language", value: language.rawValue))}
        if let sortBy {items.append(URLQueryItem(name: "sort_by", value: sortBy.rawValue))}
        if let voteAverageGte {items.append(URLQueryItem(name: "vote_average.gte", value: String(voteAverageGte)))}
        if let withGenres, !withGenres.isEmpty {
            let genresString = withGenres.map(String.init).joined(separator: ",")
            items.append(URLQueryItem(name: "with_genres", value: genresString))
        }
        if let withOriginCountry, withOriginCountry != .all {items.append(URLQueryItem(name: "with_origin_country", value: withOriginCountry.rawValue))}
        if let withOriginalLanguage, withOriginalLanguage != .all {items.append(URLQueryItem(name: "with_original_language",
                                                               value: withOriginalLanguage.rawValue)) }
        return items
    }
}
