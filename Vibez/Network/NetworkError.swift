import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case decodingError(decodingError: Error)
    case serverError(statusCode: Int)
    case invalidResponse
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The requested URL was invalid."
        case .serverError(let statusCode):
            return "TMDB API returned HTTP status \(statusCode)."
        case .decodingError(let error):
            return "Failed to parse TMDB response: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid HTTP response."
        case .unknown(let error):
            return "An unexpected error occured: \(error.localizedDescription)"
        }
    }
}
