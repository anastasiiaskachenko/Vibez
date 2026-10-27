import SwiftData

func makeContainer(inMemory: Bool) -> (reflectionStore: ReflectionStorage, userMovieStore: UserMovieStorage) {
    let schema = Schema([ReflectionModel.self, UserMovieModel.self])
    let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
    let container: ModelContainer
    do {
        container = try ModelContainer(for: schema, configurations: [config])
    } catch {
        fatalError("Failed to initialize SwiftData container: \(error)")
    }

    let reflectionStore = ReflectionStorage(container: container)
    let userMovieStore = UserMovieStorage(container: container)

    return (reflectionStore: reflectionStore, userMovieStore: userMovieStore)
}
