import Foundation

@Observable
class CategoryMovieListState {
    let prop: UserMovieToggleParam
    let repository: MovieRepositoryProtocol

    var movies: [Movie] = []
    var isLoading: Bool = false
    var hasMorePages: Bool = true
    var errorMessage: String?

    init( prop: UserMovieToggleParam,
          repository: MovieRepositoryProtocol = Dependencies.shared.repository,
    ) {
        self.prop = prop
        self.repository = repository
    }

    func loadNextPage(reset: Bool = false) async {
        guard !isLoading, (hasMorePages || reset) else { return }

        isLoading = true
        defer { isLoading = false }

        let currentOffset = reset ? 0 : movies.count

        do {
            let newMovies = try await repository.fetchMoviesByInteraction(prop: prop, offset: currentOffset)

            if reset {
                movies = newMovies
            } else {
                let existingIds = Set(movies.map(\.id))
                let uniqueNew = newMovies.filter { !existingIds.contains($0.id) }
                movies.append(contentsOf: uniqueNew)
            }

            hasMorePages = newMovies.count > 0
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
