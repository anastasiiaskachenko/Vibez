import Foundation

struct MoviesResponseDTO: Decodable {
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let totalResults: Int
}

struct MovieDTO: Decodable {
    let adult: Bool
    let backdropPath: String?
    let id: Int
    let title: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let mediaType: String?
    let genreIds: [Int]?
    let genres: [GenreResponseDTO.GenreDTO]?
    let popularity: Double
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Int?
}
