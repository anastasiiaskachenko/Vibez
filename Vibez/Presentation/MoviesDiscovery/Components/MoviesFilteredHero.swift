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
        NavigationLink(destination: MovieDetailsView(movieId: movie.id)) {
            ZStack(alignment: .trailing) {
                Color.background

                MoviePosterWithFallback(posterPath: movie.posterPath)
                    .aspectRatio(12/16, contentMode: .fit)

                VStack {
                    Spacer()
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
                .frame(maxWidth: .infinity)
                .padding(8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))

        }
    }
}

#Preview {
    MoviesFilteredHero(movie: mockMovie)
    .foregroundStyle(Color.text)
}
