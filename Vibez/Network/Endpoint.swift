import Foundation

enum HTTPMethod: String {
    case GET
}

enum NetworkError: Error {
    case invalidURL
    case decodingError(decodingError: Error)
    case serverError(statusCode: Int)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The requested URL was invalid."
        case .serverError(let statusCode):
            return "TMDB API returned HTTP status \(statusCode)."
        case .decodingError(let error):
            return "Failed to parse TMDB response: \(error.localizedDescription)"
        case .unknown(let error):
            return "An unexpected error occured: \(error.localizedDescription)"
        }
    }
}

enum Endpoint {
    case moviesSearch(query: String)
    case moviesFilter(filters: MovieFilters)
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
        case .moviesSearch(let query):
            return [URLQueryItem(name: "query", value: query)]
        case .moviesFilter(let filters):
            return filters.toQueryItems()
        case .movieById, .genres: return nil
        }
    }
}
