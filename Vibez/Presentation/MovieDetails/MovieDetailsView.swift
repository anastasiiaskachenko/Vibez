import SwiftUI
import Playgrounds

struct MovieDetailsView: View {
    @State private var viewModel: ViewModel
    let movie: Movie
    init(repository: MovieRepositoryProtocol = Dependencies.shared.repository, movie: Movie) {
        _viewModel = State(wrappedValue: ViewModel(repository: repository, movie: movie))
        self.movie = movie
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
// MARK: I wanted to make this AsyncImage to take more height but all modifiers I tried force whole screen to overfloat the sides. Works for now because images are in good aspect ratio.
                HStack {
                    Spacer()
                    Button {
                        viewModel.toggleIsLiked()
                    } label: {
                        Image(systemName: movie.isLiked ? "heart.fill" : "heart")
                            .padding(6)
                    }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.circle)
                }
                .padding()
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
                .mask(
                    LinearGradient(stops:
                        [
                            .init(color: .clear, location: 0.05),
                            .init(color: .black, location: 0.1),
                            .init(color: .black, location: 0.7),
                            .init(color: .clear, location: 1.0),

                        ],
                       startPoint: .top,
                       endPoint: .bottom
                    )
                )
                .ignoresSafeArea(edges: .top)

                MovieDescription(movie: movie, toggleIsSaved: viewModel.toggleIsSaved, toggleIsWatched: viewModel.toggleIsWatched)
            }
        }
        .background(Color.background)
        .foregroundStyle(Color.text)
    }
}

#Preview {
    MovieDetailsView(repository: MockMovieRepository(), movie: mockMovie)
}
