struct OpenRouterResponseDTO: Decodable {
    let id: String?
    let model: String?
    let choices: [Choice]?
}

struct Choice: Decodable {
    let index: Int
    let message: Message
    let finishReasoning: String?

    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReasoning = "finish_reasoning"
    }
}

struct Message: Encodable, Decodable {
    let role: String
    let content: String?
}
