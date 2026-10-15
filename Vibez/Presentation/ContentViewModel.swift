import Foundation
import SwiftData

extension ContentView {
    @Observable
    class ViewModel {
        var repository: MovieRepository
        init() throws {
            let schemaReflection = Schema([ReflectionModel.self])
            let configReflection = ModelConfiguration(schema: schemaReflection, isStoredInMemoryOnly: true)
            let containerReflection = try ModelContainer(for: schemaReflection, configurations: [configReflection])
            let reflectionStore = ReflectionStorage(container: containerReflection)

            let schemaUserMovie = Schema([UserMovieModel.self])
            let configUserMovie  = ModelConfiguration(schema: schemaUserMovie, isStoredInMemoryOnly: true)
            let containerUserMovie  = try ModelContainer(for: schemaUserMovie, configurations: [configUserMovie])
            let userMovieStore = UserMovieStorage(container: containerUserMovie)

            self.repository = MovieRepository(
                tmdbClient: NetworkClient(),
                userMovieStore: userMovieStore,
                reflectionStore: reflectionStore
            )
        }
    }
}
