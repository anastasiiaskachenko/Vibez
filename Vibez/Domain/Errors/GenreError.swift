import Foundation

enum GenreError: Error, Equatable {
    case NetworkError
    case unknown(String)
}
