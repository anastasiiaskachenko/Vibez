import Foundation

enum HTTPMethod: String {
    case GET
}

enum Endpoint {
    case moviesSearch(query: String, page: Int)
    case moviesFilter(filters: MovieFilters, page: Int)
    case movieById(movieId: Int)
    case genres

    var path: String {
        switch self {
        case .moviesSearch: return "/3/search/movie"
        case .moviesFilter: return "/3/discover/movie"
        case .movieById(let movieId): return "/3/movie/\(movieId)"
        case .genres: return "/3/genre/movie/list"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .moviesSearch, .moviesFilter, .movieById, .genres: return .GET
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .moviesSearch(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page))]
        case .moviesFilter(let filters, let page):
            var queryItemsFilters = filters.toQueryItems()
            queryItemsFilters.append(URLQueryItem(name: "page", value: String(page)))
            return queryItemsFilters
        case .movieById, .genres: return nil
        }
    }
}
