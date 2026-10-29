import Foundation

extension ReflectionsView {
    @Observable
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
/*
        func loadGenres() async {
            isLoading = true
            defer { isLoading = false}
            do {
                self.genres = try await repository.getGenres()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
 */

        func runGeneration() async {
            print("--- [DEBUG INFO] ---")
                print("Device: iPhone 13")
                print("Router Status: \(router.currentTierStatus)")
                print("Llama Ready on Disk?: \(await LlamaModelManager.shared.isModelReady)")
                print("Local Model Path: \(await LlamaModelManager.shared.localModelURL.path)")
                print("--------------------")
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
