import Foundation
import SwiftData


@Model
final class ReflectionModel: Identifiable {
    @Attribute(.unique) var id: UUID
    var movieId: Int
    var prompt: String
    var content: String
    var createdAt: Date


    init(movieId: Int, prompt: String, content: String, createdAt: Date) {
        self.id = UUID()
        self.movieId = movieId
        self.prompt = prompt
        self.content = content
        self.createdAt = createdAt
    }
}
