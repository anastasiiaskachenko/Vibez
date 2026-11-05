import Foundation

let PAGELIMIT = 500

protocol APIRequest {
    associatedtype Response: Decodable
    var endpoint: Endpoint { get }
    var url: URL? { get }
    var headers: [String: String]? { get }
    var body: OpenRouterRequestDTO? { get }
}

extension APIRequest {
    var headers: [String: String]? { nil }
    var body: OpenRouterRequestDTO? { nil }

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

struct POSTOpenRouterRequest: APIRequest {
    typealias Response = OpenRouterResponseDTO
    let endpoint: Endpoint
    let url: URL?
    let body: OpenRouterRequestDTO?
    let headers: [String: String]?

    init(body: OpenRouterRequestDTO) {
        self.endpoint = .openRouter
        self.url = URL(string: AppEnvironment.openrouterPath)
        self.headers = [
            "Authorization": "Bearer \(AppEnvironment.openRouterKey)",
            "Content-Type": "application/json"
        ]
        self.body = body
    }
}
