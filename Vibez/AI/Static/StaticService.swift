import Foundation
import SwiftLlama



struct StaticService: LLMWorkerServiceProtocol {
    var isAvailable: Bool { true }

    private let fallbackQuestions = [
            "Which character's choices resonated most with your personal values, and why?",
            "If you could alter a single pivotal decision in the story, what would change?",
            "What underlying theme or moral conflict in this film felt most relevant to your life today?",
            "How did the visual atmosphere or soundtrack shape your emotional reaction to the climax?",
            "What question would you ask the director about the unresolved elements of the ending?"
        ]

    func generatePrompts(for overview: String) async throws -> [String] {
        return fallbackQuestions
    }
}
