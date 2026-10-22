import SwiftUI
import Playgrounds

struct MovieCard: View {
    let movie: Movie
    var  year: String {
        movie.releaseDate?.formatted(.dateTime.year()) ?? ""
    }
    var genre: String {
        movie.genres?.first?.name ?? ""
    }
    var body: some View {
        NavigationLink(destination: MovieDetailsView(movieId: movie.id)) {
            VStack(alignment: .leading) {
                Spacer()
                VStack {
                    Text(movie.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .padding(.horizontal, 6)
                        .padding(.top, 4)
                    Text("\(year) • \(genre)")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 6)
                }
                .background(Color.background.opacity(0.3))
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(9/16, contentMode: .fit)
            .background(
                AsyncImage(url: movie.posterPath) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.background
                            ProgressView()
                        }
                    case .success(let image): 
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        Image("notFound")
                            .resizable()
                            .scaledToFill()
                    @unknown default:
                        Image("notFound")
                            .resizable()
                            .scaledToFill()
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}


#Preview {
    MovieCard(movie: Movie(
        id: 550,
        adult: false,
        backdropPath: URL(string: "https://image.tmdb.org/t/p/w500/8YFL5QQVPy3AgrEQxNYVSgiPEbe.jpg"),
        title: "Fight Club",
        originalLanguage: "en",
        originalTitle: "Fight Club",
        overview: "An ticking time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy.",
        posterPath: URL(string: "https://image.tmdb.org/t/p/w500/pB8BM8LLE8S1B3PyS24C3R1A23C.jpg"),
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
    ))
}


