import Testing
@testable import Vibez

struct FoundationModelsTests {

    @Test("Foundation models are required", .enabled(if: FoundationModelsService().isAvailable))
    func testReflectionQuestionGeneration() async throws {
        let service = FoundationModelsService()

        guard await service.isAvailable else {
            print("Skipped: Apple Intelligence is unavaliable in this simulator/device")
            return
        }

        let questions = try await service.generateQuestions(for: Movie.mock.overview)

        #expect(!questions.isEmpty)
        print("[Foundation model] Generated \(questions.count) questions:")
        for (index, question) in questions.enumerated() {
            print("\(index + 1). \(question)")
        }
    }
}
