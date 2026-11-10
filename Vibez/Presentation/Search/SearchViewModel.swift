import SwiftUI

extension SearchView {
    @Observable
    @MainActor
    class ViewModel {
        let repository: MovieRepositoryProtocol
        var suggestionMovies: [Movie] = []
        var errorMessage: String?
        var isLoading: Bool = false
        var page: Int = 1

        @ObservationIgnored
        private var saveTasks: [String: Task<Void, Never>] = [:]

        init(repository: MovieRepositoryProtocol) {
            self.repository = repository
        }

        func loadDefaultMovies() async {
            guard  !isLoading else { return }
            self.errorMessage = nil

            isLoading = true
            defer { isLoading = false}

            do {
                let response = try await repository.getMoviesFilter(filters: MovieFilters(sortBy: .popularityDesc), page: page)

                self.suggestionMovies = response.movies
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }

        func loadMovies(query: String) async {
            guard !isLoading else { return }
            self.errorMessage = nil

            isLoading = true
            defer { isLoading = false}

            do {
                let response = try await repository.getMoviesSearch(query: query, page: page)

                self.suggestionMovies = response

                print("load movies for query \(query), page: \(page)")
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }

        func onChange(query: String) {

            saveTasks[query]?.cancel()

            saveTasks[query] = Task {
                do {
                    try await Task.sleep(nanoseconds: 3_000_000_00)

                    self.suggestionMovies = try await repository.getMoviesSearch(query: query, page: page)

                } catch {
                    if !(error is CancellationError) {
                        self.errorMessage = "Failed to search for movies. \(error.localizedDescription)"
                    }
                }
            }
        }
    }
}
