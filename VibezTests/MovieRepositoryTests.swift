import Foundation
import SwiftData
import Testing
@testable import Vibez

@MainActor
struct MovieRepositoryTests {
    var repository: MovieRepository
    var reflectionStore: ReflectionStorage
    var userMovieStore: UserMovieStorage
    private let testMovieId = 505

    init() throws {
        let schemaReflection = Schema([ReflectionModel.self])
        let configReflection = ModelConfiguration(schema: schemaReflection, isStoredInMemoryOnly: true)
        let containerReflection = try ModelContainer(for: schemaReflection, configurations: [configReflection])
        self.reflectionStore = ReflectionStorage(container: containerReflection)

        let schemaUserMovie = Schema([UserMovieModel.self])
        let configUserMovie  = ModelConfiguration(schema: schemaUserMovie, isStoredInMemoryOnly: true)
        let containerUserMovie  = try ModelContainer(for: schemaUserMovie, configurations: [configUserMovie])
        self.userMovieStore = UserMovieStorage(container: containerUserMovie)

        self.repository = MovieRepository(
            tmdbClient: NetworkClient(),
            userMovieStore: userMovieStore,
            reflectionStore: reflectionStore
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

        #expect(moviesSearchResponse.contains(where: { $0.title == "Det sjunde inseglet" }))
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

        let createdReflection = try repository.fetchReflectionsByMovieId(movieId: testMovieId)
        #expect(createdReflection[0].movieId == testMovieId)
    }

    @Test func testUpdatingReflection() throws {
        try repository.createReflection(reflection: Reflection(
            movieId: testMovieId,
            prompt: "What did you learn from this movie",
            content: "Frogs are green",
            updatedAt: Date.now
        ))

        let createdReflection = try repository.fetchReflectionsByMovieId(movieId: testMovieId)

        try repository.updateReflection(id: createdReflection[0].id, newReflection: Reflection(
            movieId: testMovieId,
            prompt: "What did you learn from this movie",
            content: "Frogs are green, but sometimes yellow",
            updatedAt: Date.now
        ))

        guard let updatedReflection = try repository.fetchReflectionById(id: createdReflection[0].id) else {
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

        let createdReflection = try repository.fetchReflectionsByMovieId(movieId: testMovieId)
        try repository.deleteReflection(id: createdReflection[0].id)
        let deletedReflection = try repository.fetchReflectionsByMovieId(movieId: testMovieId)
        #expect(deletedReflection.count == 0)
    }

    // test user movie interactions

    @Test func testToggleIsLiked() throws {
        try userMovieStore.saveUserMovie(movieId: testMovieId)
        try  repository.toggleUserMovieIsLiked(id: testMovieId)
        let updatedUserMovie = try userMovieStore.fetchUserMovie(byID: testMovieId)
        #expect(updatedUserMovie?.liked == true)
    }

    @Test func testToggleIsSaved() throws {
        try userMovieStore.saveUserMovie(movieId: testMovieId)
        try  repository.toggleUserMovieIsSaved(id: testMovieId)
        let updatedUserMovie = try userMovieStore.fetchUserMovie(byID: testMovieId)
        #expect(updatedUserMovie?.saved == false)
    }

    @Test func testToggleIsWatched() throws {
        try userMovieStore.saveUserMovie(movieId: testMovieId)
        try  repository.toggleUserMovieIsWatched(id: testMovieId)
        let updatedUserMovie = try userMovieStore.fetchUserMovie(byID: testMovieId)
        #expect(updatedUserMovie?.watched == true)
    }
}
