import Testing
@testable import Vibez

struct RemoteModelsTest {
    @Test func testReflectionQuestionGeneration() async throws {
        let service = await RemoteModelService()
        let questions = try await service.generatePrompts(for: Movie.mock.overview)

        #expect(!questions.isEmpty)
        print("[Remote] Generated \(questions.count) questions:")
        for (index, question) in questions.enumerated() {
            print("\(index + 1). \(question)")
        }
    }
}
