import SwiftUI

struct WatchlistView: View {
    @State private var viewModel: ViewModel
    @State var openFiltersPanel: Bool = false

    init(repository: MovieRepositoryProtocol = Dependencies.shared.repository) {
        _viewModel = State(wrappedValue: ViewModel(repository: repository))
    }

    var body: some View {
        VStack {
            MovieListHorizontal(
                movies: viewModel.movies,
                listTitle: "Want to see",
                navTitle: "Reorder",
                listDestination: TestView()
            )
        }
    }
}


#Preview {
    WatchlistView(repository: MockMovieRepository())
        .background(Color.background)
        .foregroundStyle(Color.text)
}
