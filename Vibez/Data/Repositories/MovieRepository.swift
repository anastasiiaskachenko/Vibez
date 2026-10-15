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

    // Pass-throughs tmdb funcs

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

    // puts together local stored data and tmdb details
    func getMovieById(movieId: Int) async throws -> Movie {
        let movieDTO = try await tmdbClient.send(GetMovieByIdRequest(movieId: movieId))

        guard let userInteractions = try userMovieStore.fetchUserMovie(byID: movieDTO.id) else {
            try userMovieStore.saveUserMovie(movieId: movieDTO.id, isLiked: false, isWatched: false, isSaved: false)
            return movieDTO.toDomain(isSaved: false, isLiked: false, isWatched: false)
        }

        return movieDTO.toDomain(
            isSaved: userInteractions.saved,
            isLiked: userInteractions.liked,
            isWatched: userInteractions.watched
        )
    }

    // pass-through user interactions

    func toggleUserMovieIsLiked(id: Int) throws {
        try userMovieStore.toggleUserMovieIsLiked(movieId: id)
    }

    func toggleUserMovieIsSaved(id: Int) throws {
        try userMovieStore.toggleUserMovieIsSaved(movieId: id)
    }

    func toggleUserMovieIsWatched(id: Int) throws {
        try userMovieStore.toggleUserMovieIsWatched(movieId: id)
    }

    // pass-through reflections
    func createReflection(reflection: Reflection) throws {
        try reflectionStore.saveReflection(reflection: reflection)
    }

    func fetchReflectionsByMovieId(movieId: Int) throws -> [Reflection] {
        let reflectionModels = try reflectionStore.fetchReflectionsByMovieId(movieId: movieId)
        return reflectionModels.map { $0.toDomain() }
    }

    func fetchReflectionById(id: UUID) throws -> Reflection? {
        try reflectionStore.fetchReflectionById(byID: id)?.toDomain()
    }

    func updateReflection(id: UUID, newReflection: Reflection) throws {
        try reflectionStore.updateReflection(byID: id, newReflection: newReflection)
    }

    func deleteReflection(id: UUID) throws {
        try reflectionStore.deleteReflection(id: id)
    }
}
