 import Foundation

// URLSession setup, URLCache configuration, generic request helper

final class TMDBClient: TmdbClientProtocol, @unchecked Sendable {
    private let session: URLSession
    
    init () {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let tmdbCacheURl = cachesDirectory.appendingPathComponent("TMDBCache")
        
        let customCache = URLCache(
            memoryCapacity: 10 * 1024 * 1024,
            diskCapacity: 50 * 1024 * 1024,
            directory: tmdbCacheURl
        )
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = customCache
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.timeoutIntervalForRequest = 30.0
        
        self.session = URLSession(configuration: configuration)
    }
    
    func fetchGenres() async throws -> [Genre] {
        let response: GenreResponseDTO = try await self.request(
            path: "/genre/movie/list",
            cachePolicy: .returnCacheDataElseLoad
        )
        return response.genres
    }
    
    func fetchMovieById(id: Int) async throws -> MovieDTO {
        let movie: MovieDTO =  try await self.request(
            path: "/movie/\(id)",
            cachePolicy: .returnCacheDataElseLoad
        )
        return movie
    }
    
    func fetchMoviesSearch(page: Int = 1, query: String) async throws -> [MovieDTO] {
        let response: TMDBPaginatedResponse<MovieDTO> = try await self.request(
            path: "/search/movie",
            queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "query", value: "\(query)")
            ],
            cachePolicy: .returnCacheDataElseLoad
        )
        return response.results
    }
    
    func fetchMoviesWithFilters(page: Int = 1, filters: MovieFilters) async throws -> [MovieDTO] {
        var queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        queryItems.append(contentsOf: filters.toQueryItems())
        let response: TMDBPaginatedResponse<MovieDTO> = try await request(
            path: "/discover/movie",
            queryItems: queryItems,
            cachePolicy: .useProtocolCachePolicy // Respect default HTTP caching
        )
        return response.results
    }
    
    
    private func request<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem] = [],
        cachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy
    ) async throws -> T {
        guard var components = URLComponents(string: AppEnvironment.tmdbAPIbaseURL + path) else {
            throw TMDBError.invalidURL
        }
        
        var allQueryItems = [URLQueryItem(name: "api_key", value: AppEnvironment.tmdbAPIKey)]
        allQueryItems.append(contentsOf: queryItems)
        components.queryItems = allQueryItems
        
        guard let url = components.url else {
            throw TMDBError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 30)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw error
        }
        
        guard let httpRespone = response as? HTTPURLResponse else {
            throw TMDBError.invalidResponse
        }
        
        guard (200...299).contains(httpRespone.statusCode) else {
            throw TMDBError.httpError(statusCode: httpRespone.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw TMDBError.decodingError(error)
        }
    }
}
