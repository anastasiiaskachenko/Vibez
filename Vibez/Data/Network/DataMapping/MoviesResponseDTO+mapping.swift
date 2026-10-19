import Foundation

extension MovieDTO {
    func toDomain(isSaved: Bool = true, isLiked: Bool = false, isWatched: Bool = false) -> Movie {
        let genreIds = genreIds ?? genres?.map(\.id)
        let poster = posterPath.flatMap { URL(string: AppEnvironment.tmdbPosterPath + $0)}
        let backdrop = backdropPath.flatMap { URL(string: AppEnvironment.tmdbBackdropPath + $0)}

        return Movie(
            id: self.id,
            adult: self.adult,
            backdropPath: backdrop,
            title: self.title,
            originalLanguage: self.originalLanguage,
            originalTitle: self.originalTitle,
            overview: self.overview,
            posterPath: poster,
            mediaType: self.mediaType,
            genreIds: genreIds ?? [],
            popularity: self.popularity,
            releaseDate: releaseDate.flatMap { dateFormatter.date(from: $0) },
            voteAverage: self.voteAverage,
            voteCount: self.voteCount,
            isSaved: isSaved,
            isWatched: isWatched,
            isLiked: isLiked
        )
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.timeZone = TimeZone(identifier: "Europe/Stockholm")
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
