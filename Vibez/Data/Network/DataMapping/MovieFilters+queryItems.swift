import Foundation

extension MovieFilters {
    func toQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let includeAdult {items.append(URLQueryItem(name: "include_adult", value: String(includeAdult))) }
        if let language {items.append(URLQueryItem(name: "language", value: language))}
        if let region {items.append(URLQueryItem(name: "region", value: region))}
        if let sortBy {items.append(URLQueryItem(name: "sort_by", value: sortBy.rawValue))}
        if let voteAverageGte {items.append(URLQueryItem(name: "vote_average.gte", value: String(voteAverageGte)))}
        if let voteAverageLte {items.append(URLQueryItem(name: "vote_average.lte", value: String(voteAverageLte)))}
        if let withGenres, !withGenres.isEmpty {
            let genresString = withGenres.map(String.init).joined(separator: ",")
            items.append(URLQueryItem(name: "with_genres", value: genresString))
        }
        if let withOriginCountry {items.append(URLQueryItem(name: "with_origin_country", value: withOriginCountry))}
        if let withOriginalLanguage {items.append(URLQueryItem(name: "with_original_language",
                                                               value: withOriginalLanguage)) }
        if let year {items.append(URLQueryItem(name: "year", value: String(year)))}
        return items
    }
}
