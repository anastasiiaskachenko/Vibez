import SwiftUI

struct MovieCardHorizontal: View {
    let movie: Movie
    var  year: String {
        movie.releaseDate?.formatted(.dateTime.year()) ?? ""
    }
    var genre: String {
        movie.genres.first?.name ?? ""
    }

    //define on open reflection function

    var onToggleProp: (ToggleProps, Int) async -> Void
    var onOpenReflection: () -> Void

    var buttonIcon: String {
        if movie.isSaved {
            return "checkmark"
        } else if movie.isWatched {
            return "bookmark.fill"
        } else if movie.isLiked {
            return "heart.fill"
        }
        return ""
    }

    var buttonLabel: String {
        if movie.isSaved {
            return "Mark as watched"
        } else if movie.isWatched {
            return "Go to reflections"
        } else if movie.isLiked {
            return "Liked"
        }
        return ""
    }

    var body: some View {
        NavigationLink(destination: MovieDetailsView(movieId: movie.id)) {
            VStack {
                HStack {
                    MoviePosterWithFallback(posterPath: movie.posterPath, fades: false)
                        .frame(width: 75, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    VStack {
                        Text(movie.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                            .truncationMode(.middle)
                            .padding(.horizontal, 6)
                            .padding(.top, 4)
                        Text("\(year) • \(genre)")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 6)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .frame(maxWidth: 150)
                }
                Button {
                    if movie.isSaved {
                        Task {
                            await onToggleProp(.isWatched, movie.id)
                        }
                    } else if movie.isWatched {
                        onOpenReflection()
                    } else if movie.isLiked {
                        Task {
                            await onToggleProp(.isLiked, movie.id)
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: buttonIcon)
                        Text(buttonLabel)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(Color.accent)
                    .frame(alignment: .center)
                }
                .frame(maxWidth: .infinity ,alignment: .trailing)
            }
            .padding(16)
            .frame(width: 250, height: 145)
            .background(.bgSecondaryLight)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    MovieCardHorizontal(
        movie: Movie.mock,
        onToggleProp: {_,_ in },
        onOpenReflection: {}
    )
}
