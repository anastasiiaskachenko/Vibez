import SwiftUI

struct MoviesFilteredView: View {
    @State var viewModel: ViewModel
    var body: some View {
        VStack {
            ScrollView {
                MovieList(viewModel: viewModel)
            }
        }
        .task {
            await viewModel.loadMovies()
        }
    }
}
