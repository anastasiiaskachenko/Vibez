import Foundation

extension MovieDetailsView {
    @Observable
    class ViewModel {
        let repository: MovieRepositoryProtocol
        var movie: Movie
        var page: Int = 0
        var isLoading: Bool = false
        var errorMessage: String?
        var isLastPage: Bool = false
        var movieFilters: MovieFilters?

        init(repository: MovieRepositoryProtocol, movie: Movie) {
            self.repository = repository
             self.movie = movie
        }


    }
}
