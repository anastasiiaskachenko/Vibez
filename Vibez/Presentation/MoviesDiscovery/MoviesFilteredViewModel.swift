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
        var movieFilters: MovieFilters
        let initialFilters: MovieFilters

        init(repository: MovieRepositoryProtocol, movieFilters: MovieFilters) {
            self.repository = repository
             self.movieFilters = movieFilters
            self.initialFilters = movieFilters
        }

        func resetFilters() { movieFilters = initialFilters}

        func loadMovies(loadMore: Bool) async {
            guard !isLoading, !isLastPage else { return }
            self.errorMessage = nil

            isLoading = true
            defer { isLoading = false}

            do {
                let response = try await repository.getMoviesFilter(filters: movieFilters, page: page)

                if loadMore {
                    self.movies += response.movies
                } else {
                    self.movies = response.movies
                }
                self.isLastPage = response.isLastPage

                if !self.isLastPage { self.page += 1}
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
