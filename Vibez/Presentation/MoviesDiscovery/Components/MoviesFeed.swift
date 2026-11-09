import SwiftUI

struct MovieFeed: View {
    let movies: [Movie]
    var loadMore: () async -> Void

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
            ForEach(movies) { movie in
                MovieCard(movie: movie)
                .onAppear {
                    if movie.id == movies.last?.id {
                        Task {
                            await loadMore()
                        }
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
    }
}
