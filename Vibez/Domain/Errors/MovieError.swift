import Foundation

enum MovieError: Error, Equatable {
    case NetworkError
    case MovieNotFound
    case InvalidFilters
    case unknown(String)
}
