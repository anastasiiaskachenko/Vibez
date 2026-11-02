import Foundation

extension ReflectionsView {
    @Observable
    @MainActor
    class ViewModel {
        let repository: MovieRepositoryProtocol
        let router = QuestionGenerationRoutingService()
        var questions: [String] = []
        var movie: Movie
        var errorMessage: String?
        var isLoading: Bool = false
        var isDownloading: Bool = false
        var downloadProgress: Double = 0
        init(repository: MovieRepositoryProtocol, movie: Movie) {
            self.repository = repository
            self.movie = movie
        }

        func runGeneration() async {
            guard !isLoading else { return }
            isLoading = true
            errorMessage = nil
            do {
                self.questions = try await router.generatePrompts(for: movie.overview)
            } catch {
                self.errorMessage = error.localizedDescription
            }

            isLoading = false
        }

        func startDownloadAndGenerate() {
            isDownloading = true
            errorMessage = nil

            Task {
                do {
                    try await router.downloadModel { [weak self] progress in
                        Task { @MainActor in
                            self?.downloadProgress = progress
                        }
                    }
                    await MainActor.run {
                        self.isDownloading = false
                    }
                    await runGeneration()
                } catch {
                    await MainActor.run {
                        self.errorMessage = "Download failed: \(error.localizedDescription)"
                        self.isDownloading = false
                    }
                    await runGeneration()
                }
            }
        }

        func resetModelState() async {
            try? await LlamaModelManager.shared.deleteModel()

            UserDefaults.standard.removeObject(forKey: "isLlamaModelApproved")

            self.questions = []
            self.isLoading = false
            self.isDownloading = false
            self.downloadProgress = 0
            self.errorMessage = nil
        }
    }
}
