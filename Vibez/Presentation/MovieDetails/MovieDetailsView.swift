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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                // TODO: move this to a component PosterImage(path: movie.posterPath)
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
                .toolbar(.hidden, for: .tabBar)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            let _ = print("toggled is liked on movie \(movie.id)")
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
