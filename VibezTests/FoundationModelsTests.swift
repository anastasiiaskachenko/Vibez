import Testing
@testable import Vibez

struct FoundationModelsTests {
    @Test func testReflectionQuestionGeneration() async throws {
        let service = await FoundationModelsService()

        guard await service.isAvailable else {
            print("Skipped: Apple Intelligence is unavaliable in this simulator/device")
            return
        }

        let questions = try await service.generatePrompts(for: mockMovieOverview)

        #expect(!questions.isEmpty)
        print("[Foundation model] Generated \(questions.count) questions:")
        for (index, question) in questions.enumerated() {
            print("\(index + 1). \(question)")
        }
    }
}
