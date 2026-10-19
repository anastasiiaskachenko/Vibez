import Foundation

struct Reflection: Identifiable, Equatable {
    let id: UUID
    let movieId: Int
    var prompt: String?
    var content: String
    let updatedAt: Date

    init(id: UUID = UUID(), movieId: Int, prompt: String?, content: String, updatedAt: Date) {
        self.id = id
        self.movieId = movieId
        self.prompt = prompt
        self.content = content
        self.updatedAt = updatedAt
    }
}
