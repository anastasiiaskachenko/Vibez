import SwiftUI

@main struct VibezApp: App {
    let repository: MovieRepositoryProtocol
    init() {
        let container = makeContainer(inMemory: false)

        self.repository = MovieRepository(
            tmdbClient: NetworkClient(),
            userMovieStore: container.userMovieStore,
            reflectionStore: container.reflectionStore
        )
    }
    var body: some Scene {
        WindowGroup {
            MainTabView(repository: repository)
        }
    }
}
