import Foundation

enum GenreError: Error, Equatable {
    case networkError
    case unknown(String)
}
