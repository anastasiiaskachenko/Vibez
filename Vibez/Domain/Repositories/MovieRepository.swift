import Foundation

protocol MovieRepositoryProtocol {
    func getGenres() async throws -> [Genre]
    func getMoviesFilter(filters: MovieFilters, page: Int) async throws -> [Movie]
    func getMoviesSearch(query: String, page: Int) async throws -> [Movie]
    func getMovieById(movieId: Int) async throws -> Movie
}

struct MovieRepository: MovieRepositoryProtocol {
    private let tmdbClient: NetworkClient
    private let userMovieStore: UserMovieStorage
    private let reflectionStore: ReflectionStorage

    init(tmdbClient: NetworkClient, userMovieStore: UserMovieStorage, reflectionStore: ReflectionStorage) {
        self.tmdbClient = tmdbClient
        self.userMovieStore = userMovieStore
        self.reflectionStore = reflectionStore
    }

    // MARK: Pass-throughs tmdb funcs

    func getGenres() async throws -> [Genre] {
        let genresDTO = try await tmdbClient.send(GetGenresRequest())
        return genresDTO.genres.map { $0.toDomain() }
    }

    func getMoviesSearch(query: String, page: Int = 1) async throws -> [Movie] {
        let moviesDTO = try await tmdbClient.send(GetMoviesSearchRequest(query: query, page: page))
        return moviesDTO.results.map { $0.toDomain() }
    }

    func getMoviesFilter(filters: MovieFilters, page: Int = 1) async throws -> [Movie] {
        let moviesDTO = try await tmdbClient.send(GetMoviesFilterRequest(filters: filters, page: page))
        return moviesDTO.results.map { $0.toDomain() }
    }

    // MARK: Put together local stored data and tmdb details
    func getMovieById(movieId: Int) async throws -> Movie {
        let movieDTO = try await tmdbClient.send(GetMovieByIdRequest(movieId: movieId))

        let userInteractions = try userMovieStore.fetchUserMovie(byMovieID: movieDTO.id)

        return movieDTO.toDomain(
            isSaved: userInteractions?.isSaved ?? false,
            isLiked: userInteractions?.isLiked ?? false,
            isWatched: userInteractions?.isWatched  ?? false
        )
    }

    // MARK: Pass-through user interactions

    func toggleUserMovieIsLiked(id: Int) throws {
        try userMovieStore.toggleUserMovieParam(movieId: id, param: .isLiked)
    }

    func toggleUserMovieIsSaved(id: Int) throws {
        try userMovieStore.toggleUserMovieParam(movieId: id, param: .isSaved)
    }

    func toggleUserMovieIsWatched(id: Int) throws {
        try userMovieStore.toggleUserMovieParam(movieId: id, param: .isWatched)
    }

    // MARK: Pass-through reflections
    func createReflection(reflection: Reflection) throws {
        try reflectionStore.createReflection(reflection: reflection)
    }

    func getReflectionsByMovieId(movieId: Int) throws -> [Reflection] {
        let reflectionModels = try reflectionStore.fetchReflections(byMovieID: movieId)
        return reflectionModels.map { $0.toDomain() }
    }

    func getReflectionById(id: UUID) throws -> Reflection? {
        try reflectionStore.fetchReflection(byID: id)?.toDomain()
    }

    func updateReflection(id: UUID, newReflection: Reflection) throws {
        try reflectionStore.updateReflection(id: id, newReflection: newReflection)
    }

    func deleteReflection(id: UUID) throws {
        try reflectionStore.deleteReflection(id: id)
    }
}
