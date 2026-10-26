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

    static var tmdbPosterPath: String {
        guard let posterPath = Bundle.main.object(forInfoDictionaryKey: "POSTER_PATH") as? String,
                !posterPath.isEmpty else {
            fatalError("PosterPAth is not found, set PosterPath variable in Development.xcconfig")
        }
        return posterPath
    }

    static var tmdbBackdropPath: String {
        guard let backdropPath = Bundle.main.object(forInfoDictionaryKey: "BACKDROP_PATH") as? String,
                !backdropPath.isEmpty else {
            fatalError("BackdropPAth is not found, set BackdropPath variable in Development.xcconfig")
        }
        return backdropPath
    }

}
