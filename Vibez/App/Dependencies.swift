import Foundation

struct Dependencies {
    static var shared = Dependencies()

    var repository: MovieRepositoryProtocol

    private init() {
        let container = makeContainer(inMemory: false)

        self.repository = MovieRepository(
            tmdbClient: NetworkClient(),
            userMovieStore: container.userMovieStore,
            reflectionStore: container.reflectionStore
        )    }
}
