struct GenreResponseDTO: Decodable {
    let genres: [GenreDTO]
}

extension GenreResponseDTO {
    struct GenreDTO: Decodable {
        let id: Int
        let name: String
    }
}

extension GenreResponseDTO.GenreDTO {
    func toDomain() -> Genre {
        return Genre(
            id: self.id,
            name: self.name
        )
    }
}
