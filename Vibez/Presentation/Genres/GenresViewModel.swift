import Foundation

extension GenresView {
    @Observable
    class ViewModel {
        let repository: MovieRepositoryProtocol
        var genres: [Genre] = []
        var errorMessage: String?
        var isLoading: Bool = false
    
        init(repository: MovieRepositoryProtocol) {
            self.repository = repository
        }
    
        @MainActor
        func loadGenres() async {
            isLoading = true
            defer { isLoading = false}
            do {
                self.genres = try await repository.getGenres()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
