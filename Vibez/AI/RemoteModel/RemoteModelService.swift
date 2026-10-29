import Foundation
import SwiftLlama

enum RemoteModelServiceError: LocalizedError {
    case modelUnavailable
    case generationFailed(String)

    var errorDescription: String? {
        switch self {
        case .modelUnavailable:
            return "Model is not downloaded yet."
        case .generationFailed(let error):
            return "Failed to generate reflection prompt: \(error)"
        }
    }
}

struct RemoteModelService: LLMWorkerServiceProtocol {
    var isAvailable: Bool {
        true
    }

    func generatePrompts(for overview: String) async throws -> [String] {
        throw URLError(.notConnectedToInternet)
    }
}
