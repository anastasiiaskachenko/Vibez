import SwiftUI

struct MovieCardHorizontal: View {
    let movie: Movie
    var  year: String {
        movie.releaseDate?.formatted(.dateTime.year()) ?? ""
    }
    var genre: String {
        movie.genres.first?.name ?? ""
    }
    var body: some View {
        NavigationLink(destination: MovieDetailsView(movieId: movie.id)) {
            HStack {
                MoviePosterWithFallback(posterPath: movie.posterPath, fades: false)
                    .frame(width: 100, height: 125)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

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
                    Spacer()
                }
                .padding(.vertical, 8)
                .frame(maxWidth: 150)
            }
            .padding(16)
            .frame(width: 250, height: 145)
            .background(.bgSecondaryLight)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    MovieCardHorizontal(movie: Movie.mock)
}
