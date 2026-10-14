import Foundation

enum AppEnvironment {
    static var tmdbAPIKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String,
                !apiKey.isEmpty else {
            fatalError("Api key variable is not found. Set API_KEY variable in Development.xcconfig")
        }
        return apiKey
    }
    static var tmdbAPIHost: String {
        guard let apiHost = Bundle.main.object(forInfoDictionaryKey: "API_HOST") as? String,
                !apiHost.isEmpty else {
            fatalError("Api host is not found, set API_HOST variable in Development.xcconfig")
        }
        return apiHost
    }
}
