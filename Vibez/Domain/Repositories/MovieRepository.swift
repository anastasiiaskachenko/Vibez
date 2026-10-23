import Foundation

protocol MovieRepositoryProtocol {
    func getGenres() async throws -> [Genre]
    func getMoviesFilter(filters: MovieFilters, page: Int) async throws -> (movies: [Movie], isLastPage: Bool)
    func getMoviesSearch(query: String, page: Int) async throws -> [Movie]
    func getMovieById(movieId: Int) async throws -> Movie

    func toggleMovieIsSaved(id: Int) throws
    func toggleMovieIsWatched(id: Int) throws
    func toggleMovieIsLiked(id: Int) throws
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
        let genres = try await getGenres()
        let moviesDTO = try await tmdbClient.send(GetMoviesSearchRequest(query: query, page: page))
        let movies = moviesDTO.results.map { $0.toDomain() }
        return movies.map { movie in
            var updatedMovie = movie
            updatedMovie.genres = movie.genreIds.compactMap { id in
                genres.first(where: { $0.id == id})
            }
            return updatedMovie
        }
    }

    func getMoviesFilter(filters: MovieFilters, page: Int = 1) async throws -> (movies: [Movie], isLastPage: Bool) {
        let genres = try await getGenres()
        let response = try await tmdbClient.send(GetMoviesFilterRequest(filters: filters, page: page))
        let isLastPage = response.page >= response.totalPages
        var movies = response.results.map { $0.toDomain() }
        movies = movies.map { movie in
            var updatedMovie = movie
            updatedMovie.genres = movie.genreIds.compactMap { id in
                genres.first(where: { $0.id == id})
            }
            return updatedMovie
        }
        return (movies: movies, isLastPage: isLastPage)
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

    func toggleMovieIsLiked(id: Int) throws {
        try userMovieStore.toggleUserMovieParam(movieId: id, param: .isLiked)
    }

    func toggleMovieIsSaved(id: Int) throws {
        try userMovieStore.toggleUserMovieParam(movieId: id, param: .isSaved)
    }

    func toggleMovieIsWatched(id: Int) throws {
        try userMovieStore.toggleUserMovieParam(movieId: id, param: .isWatched)
    }

    // MARK: Pass-through reflections
    func createReflection(reflection: Reflection) throws {
        try reflectionStore.createReflection(reflection: reflection)
    }

    func fetchReflections(byMovieID movieId: Int) throws -> [Reflection] {
        let reflectionModels = try reflectionStore.fetchReflections(byMovieID: movieId)
        return reflectionModels.map { $0.toDomain() }
    }

    func fetchReflection(byID id: UUID) throws -> Reflection? {
        try reflectionStore.fetchReflection(byID: id)?.toDomain()
    }

    func updateReflection(id: UUID, newReflection: Reflection) throws {
        try reflectionStore.updateReflection(id: id, newReflection: newReflection)
    }

    func deleteReflection(id: UUID) throws {
        try reflectionStore.deleteReflection(id: id)
    }
}
