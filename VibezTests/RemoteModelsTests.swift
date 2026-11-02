import Foundation
import SwiftData
import Testing
@testable import Vibez

struct RemoteModelsTests {
    @Test func testReflectionQuestionGeneration() async throws {
        let service = await RemoteModelService()

        let questions = try await service.generatePrompts(for: mockMovieOverview)

        #expect(!questions.isEmpty)
        print("[Remote] Generated \(questions.count) questions:")
        for (index, question) in questions.enumerated() {
            print("\(index + 1). \(question)")
        }
    }
}
