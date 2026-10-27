import SwiftUI

struct MovieDescription: View {
    let movie: Movie
    let toggleProp: (ToggleProps) -> Void

    var year: String {
        movie.releaseDate?.formatted(.dateTime.year()) ?? ""
    }

    var metaInfo: String {
        [year, movie.originalLanguage.uppercased()].filter { !$0.isEmpty }.joined(separator: " • ")
    }

    var rating: String {
        guard let voteAverage = movie.voteAverage, let voteCount = movie.voteCount else {
            return ""
        }
        let formattedAverage = voteAverage.formatted(.number.precision(.fractionLength(1)))
        let formattedVoteCount = voteCount.formatted()
        return "\(formattedAverage) (\(formattedVoteCount))"

    }

    var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(movie.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 6)
                        .padding(.top, 4)
                    Spacer()
                    HStack {
                        Text(metaInfo)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text("•")
                        Image(systemName: movie.adult ? "18.circle.fill" : "18.circle")
                            .foregroundStyle(movie.adult ? .red : .text)
                    }
                }

                if !movie.genres.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(movie.genres) {genre in
                                NavigationLink { MoviesFilteredView(movieFilters: MovieFilters(withGenres: [genre.id]))
                                } label: {
                                    Text(genre.name)
                                        .padding(8)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.secondary, lineWidth: 4)
                                        )
                                }
                            }
                        }
                    }
                }

                Divider()

                Text(movie.overview)

                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.accent)
                    Text(rating)
                }
                HStack {
                    NavigationLink {
                        TestView()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "brain")
                                .font(.subheadline)
                            Text("Reflections")
                        }
                    }

                    Spacer()

                    Button {
                        toggleProp(.isWatched)
                    } label: {
                        HStack {
                            Text("Watched")
                            if movie.isWatched {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .buttonStyle(.primaryAction)
                    Button {
                        toggleProp(.isSaved)
                    } label: {
                        Image(systemName: movie.isSaved ? "bookmark.fill" : "bookmark" )
                    }
                    .buttonStyle(.secondaryAction)

                }
            }
            .padding(20)
            .background(
                LinearGradient(stops:
                                [
                                    .init(color: .background, location: 0.0),
                                    .init(color: .background, location: 0.8),
                                    .init(color: .background.opacity(0.6), location: 0.95),
                                    .init(color: .background.opacity(0.2), location: 1.0)
                                ],
                               startPoint: .bottom,
                               endPoint: .top
                              )
            )
            .frame( maxWidth: .infinity, alignment: .trailing)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary, lineWidth: 2)
                .padding(.bottom, -2)
                .clipped()
            )
    }
}
