import Foundation

struct Dependencies {
    static let shared = Dependencies()

    let repository: MovieRepositoryProtocol

    private init() {
        let container = makeContainer(inMemory: false)

        self.repository = MovieRepository(
            tmdbClient: NetworkClient(),
            userMovieStore: container.userMovieStore,
            reflectionStore: container.reflectionStore
        )
    }
}
