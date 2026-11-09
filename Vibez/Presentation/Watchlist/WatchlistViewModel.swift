import Foundation

extension WatchlistView {
    @Observable
    class ViewModel {
        let repository: MovieRepositoryProtocol
        var movies: [Movie] = [
                Movie.mock,
                Movie.mock,
                Movie.mock,
                Movie.mock,
                Movie.mock,
                Movie.mock,
                Movie.mock,
                Movie.mock,
                Movie.mock
        ]

        init(repository: MovieRepositoryProtocol) {
            self.repository = repository
        }
    }
}
