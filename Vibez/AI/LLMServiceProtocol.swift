protocol LLMServiceProtocol: Sendable {
    var isAvailable: Bool { get }
    func generatePrompts(for overview: String) async throws -> [String]
}
