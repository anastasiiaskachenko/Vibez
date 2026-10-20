import SwiftUI
import Playgrounds

struct MovieDescription: View {
    let movie: Movie
    let toggleIsSaved: () -> Void
    let toggleIsWatched: () -> Void

    var  year: String {
        movie.releaseDate?.formatted(.dateTime.year()) ?? ""
    }

    var metaInfo: String {
        [year, movie.originalLanguage.uppercased()].filter{ !$0.isEmpty }.joined(separator: " • ")
    }

    var rating: String {
        guard let voteAverage = movie.voteAverage, let voteCount = movie.voteCount else {
            return ""
        }
        let formattedAverage = String(format: "%.1f", voteAverage)
        return "\(formattedAverage)(\(voteCount))"
    }

    init(movie: Movie, toggleIsSaved: @escaping () -> Void, toggleIsWatched: @escaping () -> Void) {
        self.movie = movie
        self.toggleIsSaved = toggleIsSaved
        self.toggleIsWatched = toggleIsWatched
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(movie.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .padding(.horizontal, 6)
                    .padding(.top, 4)
                Spacer()
                HStack {
                    Text(metaInfo)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Text("•")
                    Image(systemName: movie.adult ? "18.circle.fill" : "18.circle")
                        .foregroundStyle(movie.adult ? .red : .text)
                }
            }

            if let genres = movie.genres, !genres.isEmpty  {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(genres) {genre in
                            NavigationLink { MoviesFilteredView(movieFilters: MovieFilters(withGenres: [genre.id]))
                            } label: {
                                Text(genre.name)
                                .padding(8)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.secondary, lineWidth: 4)
                                )
                            }
                        }
                    }
                }
            }

            Divider()

            VStack {
                Text(movie.overview)
            }

            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(Color.accent)
                Text(rating)
            }
            Spacer()
            HStack {
                NavigationLink{
                    TestView()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "bubble.left")
                            .font(.subheadline)
                        Text("Reflections")
                    }
                }

                Spacer()

                Group {
                    if movie.isSaved, !movie.isWatched {
                        Button("Mark as watched", systemImage: "eye", action: toggleIsWatched)
                    } else {
                        Button("Add to Watchlist", systemImage: "bookmark.badge.plus", action: toggleIsSaved)
                    }
                }
                .buttonStyle(.primaryAction)
            }
        }
        .padding(20)
        .background(
            LinearGradient(stops:
                [
                    .init(color: .black, location: 0.0),
                    .init(color: .black, location: 0.6),
                    .init(color: .clear, location: 1.0)
                ],
               startPoint: .bottom,
               endPoint: .top
            )
        )
        .frame( maxWidth: .infinity, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12)
            .stroke(Color.secondary, lineWidth: 2)
        )
        .padding(.top, -36)
    }
}
