import Foundation

enum AppEnvironment {
    static var tmdbAPIKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String,
                !apiKey.isEmpty else {
            fatalError("Api key variable is not found")
        }
        return apiKey
    }
    static var tmdbAPIbaseURL: String {
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
                !baseUrl.isEmpty else {
            fatalError("Base url variable is not found")
        }
        return baseUrl
    }
}
