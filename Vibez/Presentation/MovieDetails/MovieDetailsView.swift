import SwiftUI
import Playgrounds

struct MovieDetailsView: View {
    @State private var viewModel: ViewModel
    let movie: Movie
    var  year: String {
        movie.releaseDate?.formatted(.dateTime.year()) ?? ""
    }

    var metaInfo: String {
        "\(year) • \(movie.originalLanguage)"
    }

    init(repository: MovieRepositoryProtocol = Dependencies.shared.repository, movie: Movie) {
        _viewModel = State(wrappedValue: ViewModel(repository: repository, movie: movie))
        self.movie = movie
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
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
                .frame(maxWidth: .infinity)
                .frame(height: 350)
                .clipped()

                VStack(alignment: .leading, spacing: 16) {
                    HStack() {
                        Text(movie.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                            .truncationMode(.middle)
                            .padding(.horizontal, 6)
                            .padding(.top, 4)

                        Text(metaInfo)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 6)
                    }
                    if let genres = movie.genres, !genres.isEmpty  {
                        HStack {
                            ForEach(movie.genres) {genre in
                                NavigationLink(destination: MoviesFilteredView(movieFilters: MovieFilters(withGenres: [genre.id])))
                                    .padding(8)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.secondary, lineWidth: 4)
                                    ) {
                                        Text(genre.name)
                                    }

                            }
                        }
                    }


                    Divider()

                    VStack {
                        Text(movie.overview)
                    }

                        Spacer(minLength: 40)
                    }
                    .background(
                        LinearGradient(colors:
                            [                                      .background.opacity(0.95),
                                .background.opacity(0.95),
                                .background.opacity(1)

                            ],
                           startPoint: .top,
                           endPoint: .bottom
                        )
                    )
                    .frame(minHeight: 400, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary, lineWidth: 4)
                    )
                    .padding(.top, -36)
                }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.background)
        .foregroundStyle(Color.text)
    }
}


#Preview {
    MovieDetailsView(movie: Movie(
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
}

