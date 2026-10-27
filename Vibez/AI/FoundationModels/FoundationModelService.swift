import Foundation
import FoundationModels

@Generable
struct ReflectionQuestionsResult  {
    @Guide(description: "A list of 5 reflection questions about movie for user.")
    var questions: [String]
}

enum FoundationModelsServiceError: LocalizedError {
    case modelUnavailable
    case generationFailed(String)

    var errorDescription: String? {
        switch self {
        case .modelUnavailable:
            return "Apple Intelligence is currently unavailable on this device or turned of in the settings."
        case .generationFailed(let error):
            return "Failed to generate reflection prompt: \(error)"
        }
    }
}

protocol FoundationModelsServiceProtocol: Sendable {
    var isAvailable: Bool { get }
    func generatePrompts(for overview: String) async throws -> [String]
}

struct FoundationModelsService: FoundationModelsServiceProtocol {

    var isAvailable: Bool {
        SystemLanguageModel.default.availability == .available
    }

    func generatePrompts(for overview: String) async throws -> [String] {
        guard isAvailable else {
            throw FoundationModelsServiceError.modelUnavailable
        }

        let session = LanguageModelSession(
            instructions: Instructions(systemPrompt)
        )

        do {
            let response = try await session.respond(
                to: overview,
                generating: ReflectionQuestionsResult.self
            )

            return  response.content.questions
        } catch {
            throw FoundationModelsServiceError.generationFailed(error.localizedDescription)
        }
    }
}

