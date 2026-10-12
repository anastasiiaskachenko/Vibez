import Foundation

struct MovieRepository {
    private let tmdbClient: TmdbClientProtocol
    private let userMovieStore: LocalUserMovieStorage
    private let reflectionStore: ReflectionStorage
    
    init(tmdbClient: TMDBClient, userMovieStore: LocalUserMovieStorage, reflectionStore: ReflectionStorage) {
        self.tmdbClient = tmdbClient
        self.userMovieStore = userMovieStore
        self.reflectionStore = reflectionStore
    }
    
    // Pass-throughs tmdb funcs
    
    func fetchGenres() async throws -> [Genre] {
        try await tmdbClient.fetchGenres()
    }
    
    func fetchMoviesSearch(page: Int, query: String) async throws -> [MovieDTO]{
        try await tmdbClient.fetchMoviesSearch(page: page, query: query)
    }
    
    func fetchMoviesWithFilters(page: Int, filters: MovieFilters) async throws -> [MovieDTO] {
        try await tmdbClient.fetchMoviesWithFilters(page: page, filters: filters)
    }
    
    
    // puts together local stored data and tmdb details
    func fetchMovieById(id: Int) async throws -> MovieEntity {
        let movieDetails = try await tmdbClient.fetchMovieById(id: id)
        
        guard let userInteractions = try userMovieStore.fetchUserMovie(byID: movieDetails.id) else {
            try userMovieStore.saveUserMovie(movieId: movieDetails.id, isLiked:false, isWatched:false, isSaved: false)
            return movieDetails.toEntity(isSaved: false, isLiked: false, isWatched: false)
        }
     
        return movieDetails.toEntity(isSaved: userInteractions.saved, isLiked: userInteractions.liked, isWatched: userInteractions.watched)
    }
    
    // pass-through user interactions
    
    func toggleUserMovieIsLiked (id: Int) async throws {
        try userMovieStore.toggleUserMovieIsLiked(movieId: id)
    }
    
    func toggleUserMovieIsSaved (id: Int) async throws {
        try userMovieStore.toggleUserMovieIsSaved(movieId: id)
    }
    
    func toggleUserMovieIsWatched (id: Int) async throws {
        try userMovieStore.toggleUserMovieIsWatched(movieId: id)
    }
    
    // pass-through reflections
    
    func fetchReflectionsByMovieId(movieId: Int) throws -> [Reflection] {
        try reflectionStore.fetchReflectionsByMovieId(movieId: movieId)
    }
    
    func fetchReflectionById(id: UUID) throws -> Reflection? {
        try reflectionStore.fetchReflectionById(byID: id)
    }
    
    func updateReflection(id: UUID, newReflection: Reflection) throws {
        try reflectionStore.updateReflection(byID: id, newReflection: newReflection)
    }
    
    func deleteReflection(id: UUID) throws {
        try reflectionStore.deleteReflection(id: id)
    }
}
