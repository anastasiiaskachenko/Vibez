import Foundation

enum TMDBError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The requested URL was invalid."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .httpError(let statusCode):
            return "TMDB API returned HTTP status \(statusCode)."
        case .decodingError(let error):
            return "Failed to parse TMDB response: \(error.localizedDescription)"
        }
    }
}
