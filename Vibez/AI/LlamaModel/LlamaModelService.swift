import Foundation
import SwiftLlama

let temperature: CFloat = 0.3
let seed: UInt32 = 0
let topP: Float = 0.9

enum LlamaModelServiceError: LocalizedError {
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

struct LlamaModelService: LLMWorkerServiceProtocol {
    var isAvailable: Bool {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let path = appSupport.appendingPathComponent("Models/qwen2.5-1.5b-instruct-q4_k_m.gguf").path
        return FileManager.default.fileExists(atPath: path)
    }

    func generatePrompts(for overview: String) async throws -> [String] {
        guard isAvailable else {
            throw  LlamaModelServiceError.modelUnavailable
        }

        let modelURL = await LlamaModelManager.shared.localModelURL

        let llamaService = LlamaService(
            modelUrl: modelURL,
            config: .init(
                batchSize: 256,
                maxTokenCount: 1024,
                useGPU: true
            )
        )

        let messages = [
            LlamaChatMessage(role: .system, content: systemPrompt),
            LlamaChatMessage(role: .user, content: "Movie overview: \(overview)")
        ]

        let stream = try await llamaService.streamCompletion(
                of: messages,
                samplingConfig: .init(
                    temperature: temperature,
                    seed: seed,
                    topP: topP
                )
            )

        var fullResponse = ""

        for try await token in stream {
            fullResponse += token
        }

        let questions = parseLLMResponseBody(responseBody: fullResponse)
        return questions
    }
}
