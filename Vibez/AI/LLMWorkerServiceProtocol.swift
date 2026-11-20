protocol LLMWorkerServiceProtocol: Sendable {
    var isAvailable: Bool { get }
    func generateQuestions(for overview: String) async throws -> [String]
}
