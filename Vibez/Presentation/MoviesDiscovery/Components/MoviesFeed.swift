import SwiftUI

struct MovieList: View {
    @State var viewModel: MovieView.ViewModel
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
            ForEach(viewModel.movies) { movie in
                MovieCard(movie: movie)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
    }
}
