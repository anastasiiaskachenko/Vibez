import SwiftUI

struct GenresList: View {
    @State var genres: [Genre]
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
            ForEach(genres) { genre in
                GenreCard(genre: genre)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        GenresList(genres: [
            Genre(id: 28, name: "Action"),
            Genre(id: 37, name: "Western")
        ])
    }
}
