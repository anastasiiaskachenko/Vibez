import Foundation
import SwiftUI

extension ReflectionsView {
    @Observable
    @MainActor
    class ViewModel {
        let repository: MovieRepositoryProtocol
        let router: QuestionGenerationRoutingProtocol
        var questions: [String] = []
        var reflections: [Reflection]
        var movie: Movie
        var errorMessage: String?
        var isLoading: Bool = false
        var isDownloading: Bool = false
        var downloadProgress: Double = 0
        init(
            repository: MovieRepositoryProtocol,
            movie: Movie,
            router: QuestionGenerationRoutingProtocol? = nil
        ) {
            self.repository = repository
            self.movie = movie
            self.router = router ?? QuestionGenerationRoutingService()
            self.reflections = [
                Reflection(movieId: movie.id, prompt: yourThoughtsPrompt, content: "", updatedAt: Date.now),
                Reflection(movieId: movie.id, prompt: aboutCharacterPrompt, content: "", updatedAt: Date.now)
            ]
        }
//TODO: Once we actually save reflection update to self.reflections = response
        func fetchReflections() async {
            isLoading = true
            defer { isLoading = false}
            do {
                let response = try repository.fetchReflections(byMovieID: movie.id)
                self.reflections += response
            } catch {
                self.errorMessage = error.localizedDescription
            }
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

        func openInputBox(question: String) {
            if reflections.first(where: {$0.prompt == question}) != nil { return }

            let newReflection = Reflection(
                movieId: movie.id,
                prompt: question,
                content: "",
                updatedAt: .now
            )

            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                reflections.append(newReflection)
                self.questions.removeAll(where: { $0 == question })
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
