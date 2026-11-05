struct OpenRouterRequestDTO: Encodable {
    let model: String
    let messages: [Message]
    let temperature: Double?
    let stream: Bool?
}
