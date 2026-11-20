import Foundation

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
    let client = NetworkClient()

    var isAvailable: Bool {
        return !AppEnvironment.openRouterKey.isEmpty
    }

    func generatePrompts(for overview: String) async throws -> [String] {
        guard isAvailable else {
            throw RemoteModelServiceError.modelUnavailable
        }

        let requestBody = OpenRouterRequestDTO(
            model: AppEnvironment.AImodel,
            messages: [
                Message(
                    role: "system",
                    content: systemPrompt
                ),
                Message(
                    role: "user",
                    content: overview
                )
            ],
            temperature: Double(temperature),
            stream: false
        )

        do {
            let response = try await client.send(POSTOpenRouterRequest(body: requestBody))
            guard let firstChoice = response.choices?.first,
                  let replyContent = firstChoice.message.content,
                  !replyContent.isEmpty else {
                throw RemoteModelServiceError.generationFailed("Failed to parse response body.")
            }
            return parseLLMResponseBody(responseBody: replyContent)

        } catch let error {
            throw RemoteModelServiceError.generationFailed(error.localizedDescription)
        }
    }
}
