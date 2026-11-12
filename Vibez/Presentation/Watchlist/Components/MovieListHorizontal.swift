import SwiftUI

struct MovieListHorizontal: View {
    let moviesState: CategoryMovieListState
    let navTitle: String
    let listDestination: MoviesFeedPage
    @State var reflectionMovie: Movie?

    var onToggleProp: (ToggleProps, Int) async -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(alignment: .center,spacing: 6) {
                    Text(moviesState.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(String(moviesState.moviesCount))
                        .padding(8)
                        .background(Color.bgSecondaryLight)
                        .clipShape(Circle())
                }
                .padding(6)
                Spacer()
                NavigationLink(destination: listDestination) {
                    HStack {
                        Text(navTitle)
                        Image(systemName: "chevron.right")
                    }
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(moviesState.movies) { movie in
                        MovieCardHorizontal(
                            movie: movie,
                            onToggleProp: onToggleProp) {
                                reflectionMovie = movie
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, maxHeight: 160)
            }
        }
        .padding(.horizontal, 16)
        .navigationDestination(item: $reflectionMovie) {movie in
            ReflectionsView(movie: movie)
        }
        .task {
            await moviesState.fetchMoviesCount()
        }
    }
}
