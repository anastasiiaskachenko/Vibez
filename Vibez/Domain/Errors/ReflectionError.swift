import Foundation

enum ReflectionError: Error, Equatable {
    case notFould
    case saveFailed
    case deleteFailed
    case unknown(String)
}
