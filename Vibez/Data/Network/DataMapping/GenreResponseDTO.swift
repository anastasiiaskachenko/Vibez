struct GenreResponseDTO: Decodable {
    let genres: [GenreDTO]
}

extension GenreResponseDTO {
    struct GenreDTO: Decodable {
        let id: Int
        let name: String
    }
}
