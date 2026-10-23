import Foundation
import SwiftData
import Testing
@testable import Vibez

@MainActor
struct MovieRepositoryTests {
    var repository: MovieRepository
    var userMovieStore: UserMovieStorage
    var reflectionStore: ReflectionStorage
    private let testMovieId = 505

    init() throws {
        let storage = makeContainer(inMemory: true)
        self.userMovieStore = storage.userMovieStore
        self.reflectionStore = storage.reflectionStore

        self.repository = MovieRepository(
            tmdbClient: NetworkClient(),
            userMovieStore: storage.userMovieStore,
            reflectionStore: storage.reflectionStore
        )
    }

    // Test tmdb calls
    @Test func testGenresFetch() async throws {
        let genres = try await repository.getGenres()

        #expect(genres.count == 19)
    }

    @Test func testMoviesSearchFetch() async throws {
        let moviesSearchResponse = try await repository.getMoviesSearch(query: "Fight")

        #expect(moviesSearchResponse.contains(where: { $0.title == "Fight Club" }))
    }

    @Test func testMoviesFilterFetch() async throws {
        let moviesSearchResponse = try await repository.getMoviesFilter( filters:
                MovieFilters(language: "sv-SE", withOriginCountry: "SE"))

        #expect(moviesSearchResponse.movies.contains(where: { $0.title == "Det sjunde inseglet" }))
    }

    @Test func testMoviesPagination() async throws {
        let moviesSearchResponse1 = try await repository.getMoviesFilter( filters:
                MovieFilters(language: "sv-SE", withOriginCountry: "SE"))
        let moviesSearchResponse2 = try await repository.getMoviesFilter( filters:
                MovieFilters(language: "sv-SE", withOriginCountry: "SE"), page: 2)
        #expect(moviesSearchResponse1 != moviesSearchResponse2)
    }

    @Test func testMovieByIdFetch() async throws {
        let movieByIdResponse = try await repository.getMovieById(movieId: 490)

        #expect(movieByIdResponse.title == "The Seventh Seal")
    }

    // test ReflectionStore
    @Test func testSavingReflection() throws {
        try repository.createReflection(reflection: Reflection(
            movieId: testMovieId,
            prompt: "What did you learn from this movie",
            content: "Frogs are green",
            updatedAt: Date.now
        ))

        let createdReflection = try repository.fetchReflections(byMovieID: testMovieId)
        #expect(createdReflection[0].movieId == testMovieId)
    }

    @Test func testUpdatingReflection() throws {
        try repository.createReflection(reflection: Reflection(
            movieId: testMovieId,
            prompt: "What did you learn from this movie",
            content: "Frogs are green",
            updatedAt: Date.now
        ))

        let createdReflection = try repository.fetchReflections(byMovieID: testMovieId)

        try repository.updateReflection(id: createdReflection[0].id, newReflection: Reflection(
            movieId: testMovieId,
            prompt: "What did you learn from this movie",
            content: "Frogs are green, but sometimes yellow",
            updatedAt: Date.now
        ))

        guard let updatedReflection = try repository.fetchReflection(byID: createdReflection[0].id) else {
            print("No such reflection")
            return
        }
        #expect(updatedReflection.content == "Frogs are green, but sometimes yellow")
    }

    @Test func testDeletingReflection() throws {
        try repository.createReflection(reflection: Reflection(
            movieId: testMovieId,
            prompt: "What did you learn from this movie",
            content: "Frogs are green",
            updatedAt: Date.now
        ))

        let createdReflection = try repository.fetchReflections(byMovieID: testMovieId)
        try repository.deleteReflection(id: createdReflection[0].id)
        let deletedReflection = try repository.fetchReflections(byMovieID: testMovieId)
        #expect(deletedReflection.count == 0)
    }

    // test user movie interactions

    @Test func testToggleIsLiked() throws {

        try  repository.toggleMovieIsLiked(id: testMovieId)
        let updatedUserMovie = try userMovieStore.fetchUserMovie(byMovieID: testMovieId)
        #expect(updatedUserMovie != nil)
        #expect(updatedUserMovie?.isLiked == true)
    }

    @Test func testToggleIsSaved() throws {
        try  repository.toggleMovieIsSaved(id: testMovieId)
        let updatedUserMovie = try userMovieStore.fetchUserMovie(byMovieID: testMovieId)
        #expect(updatedUserMovie != nil)
        #expect(updatedUserMovie?.isSaved == true)
    }

    @Test func testToggleIsWatched() throws {
        try  repository.toggleMovieIsWatched(id: testMovieId)
        let updatedUserMovie = try userMovieStore.fetchUserMovie(byMovieID: testMovieId)
        #expect(updatedUserMovie != nil)
        #expect(updatedUserMovie?.isWatched == true)

    }
}
