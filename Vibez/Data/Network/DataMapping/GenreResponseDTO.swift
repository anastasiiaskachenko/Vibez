struct GenreResponseDTO: Decodable {
    let genres: [GenreDTO]
}

extension GenreResponseDTO {
    struct GenreDTO: Decodable {
            let id: Int
            var name: String
        }
}
