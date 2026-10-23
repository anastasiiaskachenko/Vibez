import Foundation

extension MoviesFilteredView {
    @Observable
    class ViewModel {
        let repository: MovieRepositoryProtocol
        var movies: [Movie] = []
        var page: Int = 0
        var isLoading: Bool = false
        var errorMessage: String?
        var isLastPage: Bool = false
        var movieFilters: MovieFilters?

        init(repository: MovieRepositoryProtocol, movieFilters: MovieFilters? = nil) {
            self.repository = repository
             self.movieFilters = movieFilters ?? nil
        }

        @MainActor
        func loadMovies() async {
            guard let filters = movieFilters, !isLoading, !isLastPage else { return }

            isLoading = true
            defer { isLoading = false}

            if !self.isLastPage { self.page += 1}
            do {
                let response = try await repository.getMoviesFilter(filters: filters, page: page)
                self.movies += response.movies
                self.isLastPage = response.isLastPage
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
