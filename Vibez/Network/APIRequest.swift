import Foundation

let PAGELIMIT = 500

protocol APIRequest {
    associatedtype Response: Decodable
    var endpoint: Endpoint { get }
}

extension APIRequest {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = AppEnvironment.tmdbAPIHost
        components.path = endpoint.path
        if let queryItems = endpoint.queryItems, !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        return components.url
    }
}

struct GetGenresRequest: APIRequest {
    typealias Response = GenreResponseDTO
    let endpoint: Endpoint = .genres
}

struct GetMovieByIdRequest: APIRequest {
    typealias Response = MovieDTO
    let endpoint: Endpoint

    init(movieId: Int) {
        self.endpoint = .movieById(movieId: movieId)
    }
}

struct GetMoviesFilterRequest: APIRequest {
    typealias Response = MoviesResponseDTO
    let endpoint: Endpoint

    init(filters: MovieFilters, page: Int = 1) {
        self.endpoint = .moviesFilter(filters: filters, page: page)
    }
}

struct GetMoviesSearchRequest: APIRequest {
    typealias Response = MoviesResponseDTO
    let endpoint: Endpoint

    init(query: String, page: Int = 1) {
        self.endpoint = .moviesSearch(query: query, page: page)
    }
}
