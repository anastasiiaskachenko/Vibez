import Foundation

extension Movie {
    static let mock = Movie(
        id: 550,
        adult: false,
        backdropPath: URL(string: "https://image.tmdb.org/t/p/w500/8YFL5QQVPy3AgrEQxNYVSgiPEbe.jpg"),
        title: "Fight Club",
        originalLanguage: "en",
        originalTitle: "Fight Club",
        overview: """
        An ticking time-bomb insomniac and a slippery soap
        salesman channel primal male aggression into a shocking new form
        of therapy.
        """,
        posterPath: URL(string: "https://image.tmdb.org/t/p/w500/jSziioSwPVrOy9Yow3XhWIBDjq1.jpg"),
        mediaType: "movie",
        genreIds: [18, 53],
        genres: [
            Genre(id: 18, name: "Drama"),
            Genre(id: 53, name: "Thriller")
        ],
        popularity: 61.416,
        releaseDate: Calendar.current.date(from: DateComponents(year: 1999, month: 10, day: 15)),
        voteAverage: 8.4,
        voteCount: 26280,
        isSaved: true,
        isWatched: false,
        isLiked: true
    )
}
