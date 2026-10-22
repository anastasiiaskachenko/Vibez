import SwiftUI
import Kingfisher
import Playgrounds

struct MovieDetailsView: View {
    @State private var viewModel: ViewModel
    let movie: Movie
    init(repository: MovieRepositoryProtocol = Dependencies.shared.repository, movie: Movie) {
        _viewModel = State(wrappedValue: ViewModel(repository: repository, movie: movie))
        self.movie = movie
    }
    var body: some View {
        VStack() {
            HStack {
                Spacer()
                Button {
                    viewModel.toggleIsLiked()
                } label: {
                    Image(systemName: movie.isLiked ? "heart.fill" : "heart" )
                        .font(.title3)
                        .padding(6)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.circle)
            }
            .padding(8)//move header inside safearead

            Spacer()

            MovieDescription(movie: movie, toggleIsSaved: viewModel.toggleIsSaved, toggleIsWatched: viewModel.toggleIsWatched)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            KFImage(movie.posterPath)
            .placeholder {
                ZStack {
                    Color.background
                    ProgressView()
                }
            }
            .onFailureView {
                Image("notFound")
                    .resizable()
                    .scaledToFill()
            }
            .onFailure { error in
                print("Failed to load image \(error)")
            }
            .resizable()
            .scaledToFill()
            .mask(
                LinearGradient(stops:
                    [
                        //.init(color: .clear, location: 0.05),
                        .init(color: .black, location: 0.1),
                        .init(color: .black, location: 0.7),
                        .init(color: .clear, location: 1.0),

                    ],
                   startPoint: .top,
                   endPoint: .bottom
                )
            )
            .ignoresSafeArea(edges: .top)
        )
        .background(Color.background)
        .foregroundStyle(Color.text)

    }
}

#Preview {
    MovieDetailsView(repository: MockMovieRepository(), movie: mockMovie)
}
