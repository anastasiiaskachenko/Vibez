import Foundation

extension MoviesFilteredView {
    @Observable
    class ViewModel {
        let repository: MovieRepository
        var movies: [Movie] = []
        var page: Int = 1
        var isLoading: Bool = false
        var errorMessage: String?
        var isLastPage: Bool = false

        init(repository: MovieRepository) {
            self.repository = repository
        }

        @MainActor
        func loadInitialMovies() async {
            isLoading = true
            defer { isLoading = false}
            do {
                let response = try await repository.getMoviesFilter(filters: MovieFilters(withGenres: [28]))
                self.movies = response.movies
                self.isLastPage = isLastPage
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
