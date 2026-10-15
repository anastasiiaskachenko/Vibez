import SwiftUI

struct GenresList: View {
    @State var viewModel: GenresView.ViewModel
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
            ForEach(viewModel.genres) { genre in
                GenreCard(genre: genre)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
    }
}
