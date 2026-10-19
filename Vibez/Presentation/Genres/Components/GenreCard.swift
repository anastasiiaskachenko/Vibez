import SwiftUI

struct GenreCard: View {
    let genre: Genre
    var body: some View {
        NavigationLink(destination: MoviesFilteredView(movieFilters: MovieFilters(withGenres: [genre.id]))) {
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Text(genre.name)
                        .padding()
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "arrow.up.right")
                        .foregroundStyle(Color.text)
                        .padding(12)
                        .background(Color.accent)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 6)
            .frame(maxWidth: .infinity)
            .aspectRatio(16/9, contentMode: .fit)
            .background(
                ZStack {
                    Image(itemId: genre.id)
                        .resizable()
                        .scaledToFill()

                    LinearGradient(colors:
                        [
                            .clear,
                            .black.opacity(0.1),
                            .black.opacity(0.8)
                        ],
                       startPoint: .top,
                       endPoint: .bottom
                      )
                }

            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 5)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        GenreCard(genre: Genre(id: 28, name: "Action"))
        .background(Color.background)
    }
}
