import Foundation

struct Reflection: Identifiable, Equatable {
    let id: UUID
    let movieId: String
    var prompt: String?
    var content: String
    let createdAt: Date
    
    
    init(id: UUID = UUID(), movieId: String, prompt: String? = nil, content: String, createdAt: Date) {
        self.id = id
        self.movieId = movieId
        self.prompt = prompt
        self.content = content
        self.createdAt = createdAt
    }
}
