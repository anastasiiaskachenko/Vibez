import Foundation
import SwiftUI

extension ReflectionsView {
    @Observable
    @MainActor
    class ViewModel {
        let repository: MovieRepositoryProtocol
        let router: QuestionGenerationRoutingProtocol
        var questions: [String] = []
        var reflections: [Reflection] = []
        var movie: Movie
        var errorMessage: String?
        var isLoading: Bool = false
        var isDownloading: Bool = false
        var downloadProgress: Double = 0

        @ObservationIgnored
        private var saveTasks: [UUID: Task<Void, Never>] = [:]

        init(
            repository: MovieRepositoryProtocol,
            movie: Movie,
            router: QuestionGenerationRoutingProtocol? = nil
        ) {
            self.repository = repository
            self.movie = movie
            self.router = router ?? QuestionGenerationRoutingService()
        }

        func fetchReflections() async {
            isLoading = true
            defer { isLoading = false}
            do {
                let response = try repository.fetchReflections(byMovieID: movie.id)

                let existingThoughts = response.first(where: {$0.prompt == yourThoughtsPrompt})
                let existingCharacter = response.first(where: {$0.prompt == aboutCharacterPrompt})

                let yourThoughtsReflection = existingThoughts ?? Reflection(
                    movieId: movie.id,
                    prompt: yourThoughtsPrompt,
                    content: "",
                    updatedAt: Date.now
                )

                let aboutCharacterReflection = existingCharacter ?? Reflection(
                    movieId: movie.id,
                    prompt: aboutCharacterPrompt,
                    content: "",
                    updatedAt: Date.now
                )

                var merged: [Reflection] = [ yourThoughtsReflection, aboutCharacterReflection ]

                let customStored = response.filter {
                    $0.prompt != yourThoughtsPrompt && $0.prompt != aboutCharacterPrompt
                }

                merged.append(contentsOf: customStored)

                self.reflections = merged
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

        func onContentChange(for reflection: Reflection) {
            let key = reflection.id

            if let currIndex = self.reflections.firstIndex(where: { $0.id == key}) {
                self.reflections[currIndex].updatedAt = .now
            }

            saveTasks[key]?.cancel()

            saveTasks[key] = Task {
                do {
                    try await Task.sleep(nanoseconds: 3_000_000_00)

                    guard let latestChanges = self.reflections.first(where: { $0.id == key}) else { return }

                    let hasContent = !latestChanges.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    let isDefaultPrompt = latestChanges.prompt == yourThoughtsPrompt || latestChanges.prompt == aboutCharacterPrompt

                    if hasContent || isDefaultPrompt {
                        try repository.updateReflection(id: latestChanges.id, newReflection: latestChanges)
                    } else {
                        try repository.deleteReflection(id: latestChanges.id)
                        self.reflections.removeAll(where: {$0.id == key})
                    }
                } catch {
                    if !(error is CancellationError) {
                        self.errorMessage = "Failed to save reflection changes. \(error.localizedDescription)"
                    }
                }
            }
        }

        // Used for testing
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
