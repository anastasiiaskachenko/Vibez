import Foundation

func testTMDBCalls() async throws {
    let client = TMDBClient()
    
    do {
        let genres = try await client.fetchGenres()
        let moviesInUkrainian = try await client.fetchMoviesWithFilters(filters: MovieFilters(language: "uk-UA"))
        let moviesForChildren = try await client.fetchMoviesWithFilters(filters: MovieFilters(includeAdult: false))
        let movieByID = try await client.fetchMovieById(id: 569094)
        let movieEntity = movieByID.toEntity(isSaved: true, isLiked: false, isWatched: false)
        
        let moviesByQuery = try await client.fetchMoviesSearch(query: "Людина-павук")
        print("Genres from TMDB:\(genres)")
        print("Movies in Ukrainian: \(moviesInUkrainian)")
        print("Movies for children: \(moviesForChildren)")
        
        print("Movies by query", moviesByQuery)
        print("\n Movie by id", movieByID)
        print("Movie by id to entity", movieEntity)
    } catch {
        print("Live call failed: \(error)")
    }
}
