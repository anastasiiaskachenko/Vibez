import Foundation
import FoundationModels

@Generable
struct ReflectionQuestionsResult {
    @Guide(description: "A list of reflection questions about movie for user.", .count(5))
    var questions: [String]
}

enum FoundationModelsServiceError: LocalizedError {
    case modelUnavailable
    case generationFailed(String)

    var errorDescription: String? {
        switch self {
        case .modelUnavailable:
            return "Apple Intelligence is currently unavailable on this device or turned off in the settings."
        case .generationFailed(let error):
            return "Failed to generate reflection prompt: \(error)"
        }
    }
}

nonisolated struct FoundationModelsService: LLMWorkerServiceProtocol {

    var isAvailable: Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        return SystemLanguageModel.default.availability == .available
        #endif
    }

    func generateQuestions(for overview: String) async throws -> [String] {
        guard isAvailable else {
            throw FoundationModelsServiceError.modelUnavailable
        }

        let session = LanguageModelSession(
            instructions: Instructions(Prompt.reflection)
        )

        do {
            let response = try await session.respond(
                to: overview,
                generating: ReflectionQuestionsResult.self
            )

            return response.content.questions
        } catch let error as CancellationError {
            throw error
        } catch {
            throw FoundationModelsServiceError.generationFailed(error.localizedDescription)
        }
    }
}
