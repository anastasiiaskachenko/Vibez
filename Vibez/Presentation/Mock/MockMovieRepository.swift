import Foundation

struct MockMovieRepository: MovieRepositoryProtocol {
    func getGenres() async throws -> [Genre] {
        return [Genre(id: 28, name: "Action")]
    }
    
    func getMoviesFilter(filters: MovieFilters, page: Int) async throws -> (movies: [Movie], isLastPage: Bool) {
        return (movies: [mockMovie], isLastPage: true)
    }
    
    func getMoviesSearch(query: String, page: Int) async throws -> [Movie] {
        return [mockMovie]
    }
    
    func getMovieById(movieId: Int) async throws -> Movie {
        return mockMovie
    }
    
    func toggleMovieIsSaved(id: Int) throws {}
    
    func toggleMovieIsWatched(id: Int) throws {}
    
    func toggleMovieIsLiked(id: Int) throws {}
    

}




