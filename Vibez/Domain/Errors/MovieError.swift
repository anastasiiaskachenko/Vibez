import Foundation

enum MovieError: Error, Equatable {
    case networkError
    case movieNotFound
    case invalidFilters
    case unknown(String)
}
