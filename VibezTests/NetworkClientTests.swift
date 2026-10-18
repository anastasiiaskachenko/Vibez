import Foundation
import SwiftData
import Testing
@testable import Vibez

@Suite(.serialized)
@MainActor
struct NetworkClientTests {
    private func makeMockClient() -> NetworkClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockUrlProtocol.self]
        let mockSession = URLSession(configuration: configuration)
        return NetworkClient(session: mockSession)
    }
    
    @Test func testGenresFetch() async throws {
        let client = makeMockClient()
        
        let mockJson = """
        {
            "genres": [
                { "id": 28, "name": "Action" },
                { "id": 12, "name": "Adventure" }
            ]
        }
        """.data(using: .utf8)!
        
        MockUrlProtocol.requestHandler["/genre/movie/list"] = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockJson)
        }
        
        let genresResponse = try await client.send(GetGenresRequest())

        #expect(genresResponse.genres.count == 2)
        #expect(genresResponse.genres.first?.name == "Action")
    }

    @Test func testMoviesSearchFetch() async throws {
        let client = makeMockClient()
        
        let mockJson = """
        {
            "page": 1,
            "results": [
                { "id": 550, "title": "Fight Club", "overview": "An insider look...", "popularity": 45.2, "adult": false, "original_language": "en", "original_title": "Fight Club" }
            ],
            "total_pages": 1,
            "total_results": 1
        }
        """.data(using: .utf8)!
        
        MockUrlProtocol.requestHandler["/search/movie"] = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockJson)
        }
        
        let moviesSearchResponse = try await client.send(GetMoviesSearchRequest(query: "Fight"))

        #expect(moviesSearchResponse.results.contains(where: { $0.title == "Fight Club" }))
    }

    @Test func testMoviesFilterFetch() async throws {
        let client = makeMockClient()
        
        let mockJson = """
        {
            "page": 1,
            "results": [
                {
                    "id": 490,
                    "title": "Det sjunde inseglet",
                    "adult": false,
                    "original_language": "sv",
                    "original_title": "Det sjunde inseglet",
                    "overview": "A knight plays chess with Death...",
                    "popularity": 22.1
                }
            ],
            "total_pages": 1,
            "total_results": 1
        }
        """.data(using: .utf8)!
        
        MockUrlProtocol.requestHandler["/discover/movie"] = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockJson)
        }
        
        let moviesSearchResponse = try await client.send(
            GetMoviesFilterRequest(filters:
                MovieFilters(language: "sv-SE", withOriginCountry: "SE")))

        #expect(moviesSearchResponse.results.contains(where: { $0.title == "Det sjunde inseglet" }))
    }

    @Test func testMovieByIdFetch() async throws {
        let client = makeMockClient()
        
        let mockJson = """
        {
            "id": 490,
            "title": "Det sjunde inseglet",
            "adult": false,
            "original_language": "sv",
            "original_title": "Det sjunde inseglet",
            "overview": "A knight plays chess with Death...",
            "popularity": 22.1
        }
        """.data(using: .utf8)!
        
        MockUrlProtocol.requestHandler["/movie/490"] = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockJson)
        }
        
        let movieByIdResponse = try await client.send(GetMovieByIdRequest(movieId: 490))

        #expect(movieByIdResponse.title == "Det sjunde inseglet")
    }
    
    @Test func testServerError() async throws {
        let client = makeMockClient()
        MockUrlProtocol.requestHandler.removeValue(forKey: "/genre/movie/list")
        
        MockUrlProtocol.requestHandler["/genre/movie/list"] = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        
        await #expect(performing: {
            try await client.send(GetGenresRequest())
        }, throws: { error in
            guard let networkError = error as? NetworkError else { return false }
            return networkError.errorDescription == "TMDB API returned HTTP status 401."
        })
    }
}
