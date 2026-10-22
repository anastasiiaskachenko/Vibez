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
                .padding(8)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(9/16, contentMode: .fit)
            .background(
                MoviePosterWithFallback(posterPath: movie.posterPath, fades: false)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}


#Preview {
    MovieCard(movie: mockMovie)
}


