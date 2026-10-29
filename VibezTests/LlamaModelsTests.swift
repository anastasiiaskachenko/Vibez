import Testing
@testable import Vibez

struct LlamaModelsTests {
    @Test func testReflectionQuestionGeneration() async throws {
        let service = await LlamaModelService()

        if await !service.isAvailable {
            try await LlamaModelManager.shared.downloadModel
                { progress in
                    print("Progress: \(progress)")
                }

        }

        let questions = try await service.generatePrompts(for: mockMovieOverview)

        #expect(!questions.isEmpty)
        print("[Llama] Generated \(questions.count) questions:")
        for (index, question) in questions.enumerated() {
            print("\(index + 1). \(question)")
        }
    }
}
