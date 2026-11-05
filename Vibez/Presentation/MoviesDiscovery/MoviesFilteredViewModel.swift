import Foundation

extension MoviesFilteredView {
    @Observable
    class ViewModel {
        let repository: MovieRepositoryProtocol
        var movies: [Movie] = []
        var page: Int = 1
        var isLoading: Bool = false
        var errorMessage: String?
        var isLastPage: Bool = false
        var movieFilters: MovieFilters?

        init(repository: MovieRepositoryProtocol, movieFilters: MovieFilters? = nil) {
            self.repository = repository
             self.movieFilters = movieFilters
        }

        func loadMovies() async {
            guard let filters = movieFilters, !isLoading, !isLastPage else { return }
            self.errorMessage = nil

            isLoading = true
            defer { isLoading = false}

            do {
                let response = try await repository.getMoviesFilter(filters: filters, page: page)

                self.movies += response.movies
                self.isLastPage = response.isLastPage

                if !self.isLastPage { self.page += 1}
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
