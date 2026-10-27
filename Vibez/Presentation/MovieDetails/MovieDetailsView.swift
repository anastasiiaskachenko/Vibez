import SwiftUI
import Kingfisher

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

                    MovieDescription(
                        movie: movie,
                        toggleProp: { prop in
                            Task {
                                await viewModel.toggleProp(prop)
                            }
                        }
                    )

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    MoviePosterWithFallback(posterPath: movie.posterPath)
                        .ignoresSafeArea(edges: .top)
                )
                .background(Color.background)
                .foregroundStyle(Color.text)
                .toolbar(.hidden, for: .tabBar)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            Task {
                                await viewModel.toggleProp(.isLiked)
                            }
                        } label: {
                            Image(systemName: movie.isLiked ? "heart.fill" : "heart" )
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.text)
                        }
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView(
                    "Failed to load movie",
                    systemImage: "wifi.exclamationmark",
                    description: Text(errorMessage)
                )
            } else {
                ProgressView()
                    .frame(maxHeight: .infinity)
            }
        }
        .whiteBackButton()
        .task {
            await viewModel.fetchMovie()
        }
    }
}

#Preview {
    MovieDetailsView(repository: MockMovieRepository(), movieId: Movie.mock.id)
}
