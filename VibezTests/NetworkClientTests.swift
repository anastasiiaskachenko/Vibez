import Foundation
import SwiftData
import Testing
@testable import Vibez

@MainActor
struct NetworkClientTests {
    @Test func testGenresFetch() async throws {
        let client = NetworkClient()
        let genresResponse = try await client.send(GetGenresRequest())

        #expect(genresResponse.genres.count == 19)
    }

    @Test func testMoviesSearchFetch() async throws {
        let client = NetworkClient()
        let moviesSearchResponse = try await client.send(GetMoviesSearchRequest(query: "Fight"))

        #expect(moviesSearchResponse.results.contains(where: { $0.title == "Fight Club" }))
    }

    @Test func testMoviesFilterFetch() async throws {
        let client = NetworkClient()
        let moviesSearchResponse = try await client.send(
            GetMoviesFilterRequest(filters:
                MovieFilters(language: "sv-SE", withOriginCountry: "SE")))

        #expect(moviesSearchResponse.results.contains(where: { $0.title == "Det sjunde inseglet" }))
    }

    @Test func testMovieByIdFetch() async throws {
        let client = NetworkClient()
        let movieByIdResponse = try await client.send(GetMovieByIdRequest(movieId: 490))

        #expect(movieByIdResponse.title == "The Seventh Seal")
    }
}
