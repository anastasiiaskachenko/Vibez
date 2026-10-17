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
        NavigationLink(destination: TestView()) {
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
