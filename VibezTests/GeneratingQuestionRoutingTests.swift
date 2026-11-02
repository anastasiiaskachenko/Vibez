import Testing
@testable import Vibez
import Foundation

struct GeneratingQuestionsRoutingTests {
    struct MockWorker: LLMWorkerServiceProtocol {
        let isAvailable: Bool
        let shouldThrow: Bool
        let output: [String]

        init(isAvailable: Bool, shouldThrow: Bool = false, output: [String] = ["Mock question"]) {
            self.isAvailable = isAvailable
            self.shouldThrow = shouldThrow
            self.output = output
        }

        func generatePrompts(for overview: String) async throws -> [String] {
            if shouldThrow { throw URLError(.badServerResponse)}
            return output
        }
    }

    private var testDefaults: UserDefaults!

    init() {
        let suiteName = "TestingDefaults-\(UUID().uuidString)"
        testDefaults = UserDefaults(suiteName: suiteName)!
        testDefaults.removePersistentDomain(forName: suiteName)
    }

    @Test("Tier 1 takes precendence when available")
    func tier1Precendence() async throws {
        let router = await  QuestionGenerationRoutingService(
            tier1Service: MockWorker(isAvailable: true, output: ["Apple Intellegence question"]),
            tier2Service: MockWorker(isAvailable: true, output: ["Llama question"]),
            userDefaults: testDefaults
        )

        #expect(router.currentTierStatus == .foundationModels)
        let results = try await router.generatePrompts(for: mockMovieOverview)
        #expect(results.first == "Apple Intellegence question")
    }

    @Test("State is unprompted when tier 1 is not available and no stored approval")
    func unPromptedState() async throws {
        let router = await  QuestionGenerationRoutingService(
            tier1Service: MockWorker(isAvailable: false),
            tier2Service: MockWorker(isAvailable: false),
            userDefaults: testDefaults
        )

        #expect(router.currentTierStatus == .llamaModelNotPrompted)
    }

    @Test("When tier 1 is not available but tier 2 is that model is called")
    func tier2Used() async throws {
        testDefaults.set(true, forKey: "isLlamaModelApproved")
        let router = await  QuestionGenerationRoutingService(
            tier1Service: MockWorker(isAvailable: false),
            tier2Service: MockWorker(isAvailable: true, output: ["Llama question"]),
            userDefaults: testDefaults
        )

        #expect(router.currentTierStatus == .llamaModelDownloaded)
        let results = try await router.generatePrompts(for: mockMovieOverview)
        #expect(results.first == "Llama question")
    }
}
