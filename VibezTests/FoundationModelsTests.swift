import Testing
@testable import Vibez

struct FoundationModelsTests {
    @Test func testReflectionQuestionGeneration() async throws {
        let service = await FoundationModelsService()

        guard await service.isAvailable else {
            print("Skipped: Appöe Intelligence is unavaliable in this simulator/device")
            return
        }

        let movieOverview =
            """
                A young girl wanders into an enchanting spirit world ruled by an ambitious sorceress, \
                where she must find inner courage, work hard, and remember her true identity to save \
                her transformed parents and return to the human world.
            """

        let questions = try await service.generatePrompts(for: movieOverview)

        #expect(!questions.isEmpty)
        print("[Foundation model] Generated \(questions.count) questions:")
        for (index, question) in questions.enumerated() {
            print("\(index + 1). \(question)")
        }
    }
}
