import Foundation
import SwiftData


@Model
final class ReflectionModel: Identifiable {
    @Attribute(.unique) var id: Int
    var movieId: Int
    var prompt: String
    var content: String
    var createdAt: Date


    init(id: Int, movieId: Int, prompt: String, content: String, createdAt: Date) {
        self.id = id
        self.movieId = movieId
        self.prompt = prompt
        self.content = content
        self.createdAt = createdAt
    }
}
