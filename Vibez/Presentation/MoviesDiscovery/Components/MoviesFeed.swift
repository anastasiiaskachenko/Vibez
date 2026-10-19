import SwiftUI

struct MovieFeed: View {
    @State var movies: [Movie]
    var loadMore: () async ->  Void
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                ForEach(movies) { movie in
                    MovieCard(movie: movie)
                        .onAppear {
                            if movie == movies.last {
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
    
    
}
