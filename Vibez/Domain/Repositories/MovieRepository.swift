import Foundation

protocol MovieRepositoryProtocol {
    func getGenres() async throws -> [Genre]
    func getMoviesFilter(filters: MovieFilters, page: Int) async throws -> MoviesPage
    func getMoviesSearch(query: String, page: Int) async throws -> [Movie]
    func getMovieById(movieId: Int) async throws -> Movie

    func toggleMovieIsSaved(id: Int) throws
    func toggleMovieIsWatched(id: Int) throws
    func toggleMovieIsLiked(id: Int) throws
    func fetchReflections(byMovieID: Int) throws -> [Reflection]
    func fetchReflection(byID: UUID) throws -> Reflection?
    func updateReflection(id: UUID, newReflection: Reflection) throws
    func deleteReflection(id: UUID) throws

    func fetchMoviesByInteraction(prop: UserMovieToggleParam, offset: Int) async throws -> [Movie]
    func fetchMoviesByInteractionsCount(byInteractions: UserMovieToggleParam) throws -> Int
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

    func getMoviesFilter(filters: MovieFilters, page: Int = 1) async throws -> MoviesPage {
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
        return MoviesPage(movies: movies, isLastPage: isLastPage)
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

    func fetchMoviesByInteractionsCount (byInteractions prop: UserMovieToggleParam) throws -> Int {
        return try userMovieStore.fetchUserMovieCount(byInteractions: prop)
    }

    func fetchMoviesByInteraction(prop: UserMovieToggleParam, offset: Int = 0) async throws -> [Movie] {
        let userInteractions = try userMovieStore.fetchUserMovies(byInteractions: prop, offset: offset) 
        let ids: [Int] = userInteractions.map({ $0.movieId})

        guard !ids.isEmpty else { return [] }

        return try await withThrowingTaskGroup(of: (Int, Movie).self) { group in
            for (index, movieId) in ids.enumerated() {
                group.addTask {
                    let movie = try await self.getMovieById(movieId: movieId)
                    return (index, movie)
                }
            }

            var indexedMovies: [(Int, Movie)] = []
            indexedMovies.reserveCapacity(ids.count)

            for try await result in group {
                indexedMovies.append(result)
            }

            return indexedMovies
                .sorted { $0.0 < $1.0 }
                .map(\.1)
        }
    }
}
