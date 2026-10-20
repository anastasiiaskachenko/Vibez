import SwiftUI
import Playgrounds

struct MoviesFilteredHero: View {
    let movie: Movie
    var  year: String {
        movie.releaseDate?.formatted(.dateTime.year()) ?? ""
    }

    var genres: String {
        movie.genres?.map(\.name).joined(separator: ", ") ?? ""
    }


    var body: some View {
        NavigationLink(destination: TestView()) {
            VStack(alignment: .leading) {
                Spacer()
                VStack {
                    Text(movie.title)
                        .fontWeight(.bold)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                        .truncationMode(.middle)
                    Text("\(year) • \(genres)")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 6)
                }
                .background(Color.background.opacity(0.3))
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(12/16, contentMode: .fit)
            .background(
                ZStack {
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
                    .ignoresSafeArea()
                    LinearGradient(colors:
                        [
                            .clear,
                            .black.opacity(0.2),
                            .black.opacity(1)
                        ],
                       startPoint: .top,
                       endPoint: .bottom
                    )
                }

            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}






#Preview {
    MoviesFilteredHero(movie: Movie(
        id: 550,
        adult: false,
        backdropPath: URL(string: "https://image.tmdb.org/t/p/w500/fCay2Z12ik19Th2ThM2L8z3A42N.jpg"),
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
    .foregroundStyle(Color.text)
}
