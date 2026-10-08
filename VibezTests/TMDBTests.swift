import Foundation
import SwiftData
import Testing
@testable import Vibez

@MainActor

struct UserMovieStorageTests {
    func testTMDBCalls() async throws {
        let client = TMDBClient()
 
        let genres = try await client.fetchGenres()
        let moviesInUkrainian = try await client.fetchMoviesWithFilters(filters: MovieFilters(language: "uk-UA"))
        let moviesForChildren = try await client.fetchMoviesWithFilters(filters: MovieFilters(includeAdult: false))
        let movieByID = try await client.fetchMovieById(id: 569094)
        let movieEntity =  movieByID.toEntity(isSaved: false, isLiked: true, isWatched: false)
        
        let moviesByQuery = try await client.fetchMoviesSearch(query: "Spider-Man")
        
        #expect(genres.count == 16)
        #expect(genres.contains(where: {$0.name == "Mystery"}))
        
        #expect(moviesInUkrainian.contains(where: {$0.title == "Людина-мураха та Оса: Квантоманія"}))
        #expect(moviesForChildren.allSatisfy { $0.adult == false })
        
        #expect(movieByID.id == 569094)
        #expect(moviesByQuery.allSatisfy { $0.title.contains("Spider-Man") })
        
        #expect(movieEntity.title == "Spider-Man: Across the Spider-Verse")
        #expect(movieEntity.isLiked == true)
    }
}
