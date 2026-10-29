import Foundation
import SwiftLlama

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

struct LlamaModelService: LLMServiceProtocol {
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


        print("[Llama] generating tokens")


        let stream = try await llamaService.streamCompletion(
                of: messages,
                samplingConfig: .init(
                    temperature: 0.3,
                    seed: 0,
                    topP: 0.9
                )
            )

        var fullResponse = ""

        for try await token in stream {
            fullResponse += token
        }

        print("[Llama] Generated raw output: \(fullResponse)")

        let questions = fullResponse
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
            .map { line in
                line.replacingOccurrences(of: "^[-*•\\d.]+\\s*", with: "", options: .regularExpression)
            }
            .filter { line in
                !line.isEmpty && line.count > 10 && !line.contains("<|im_")
            }

        return questions
    }
}
