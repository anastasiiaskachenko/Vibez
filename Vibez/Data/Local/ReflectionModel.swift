import Foundation
import SwiftData

@Model
final class ReflectionModel: Identifiable {
    @Attribute(.unique) var id: UUID
    var movieId: Int
    var prompt: String?
    var content: String
    var updatedAt: Date

    init(movieId: Int, prompt: String?, content: String, updatedAt: Date) {
        self.id = UUID()
        self.movieId = movieId
        self.prompt = prompt
        self.content = content
        self.updatedAt = updatedAt
    }

    func toDomain() -> Reflection {
        return Reflection(
            id: self.id,
            movieId: self.movieId,
            prompt: self.prompt,
            content: self.content,
            updatedAt: self.updatedAt
        )
    }
}
