import SwiftUI
import Kingfisher
import Playgrounds

struct MovieDetailsView: View {
    @State private var viewModel: ViewModel
    init(repository: MovieRepositoryProtocol = Dependencies.shared.repository, movieId: Int) {
        _viewModel = State(wrappedValue: ViewModel(repository: repository, movieId: movieId))
    }
    var body: some View {
        Group {
            if let movie = viewModel.movie {
                VStack {
                    Spacer()

                    MovieDescription(movie: movie, toggleIsSaved: viewModel.toggleIsSaved, toggleIsWatched: viewModel.toggleIsWatched)

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)                .background(
                    MoviePosterWithFallback(posterPath: movie.posterPath)
                        .ignoresSafeArea(edges: .top)
                )
                .background(Color.background)
                .foregroundStyle(Color.text)
                .toolbar(.hidden, for: .tabBar)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewModel.toggleIsLiked()
                        } label: {
                            Image(systemName: movie.isLiked ? "heart.fill" : "heart" )
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(movie.isLiked ? .accent : .black)
                        }
                    }
                }
            }
            else if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView(
                    "Failed to load movie",
                    systemImage: "wifi.exclamationmark",
                    description: Text(errorMessage)
                )
            } else  {
                ProgressView()
                    .frame(maxHeight: .infinity)
            }
        }
        .task {
            await viewModel.fetchMovie()
        }
    }
}

#Preview {
    MovieDetailsView(repository: MockMovieRepository(), movieId: mockMovie.id)
}
