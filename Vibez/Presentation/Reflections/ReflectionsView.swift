import SwiftUI

struct ReflectionsView: View {
    @State private var viewModel: ViewModel
    let movie: Movie

    init(repository: MovieRepositoryProtocol = Dependencies.shared.repository, movie: Movie) {
        self.movie = movie
        _viewModel = State(
            initialValue: ViewModel(
                repository: repository,
                movie: movie
            )
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            /*
            #if DEBUG
            Button("Reset model states", role: .destructive) {
                Task {
                    await viewModel.resetModelState()
                }
            }
            #endif
             */
            if viewModel.isDownloading {
                DownloadProgressCard(downloandProgress: viewModel.downloadProgress)
            } else if viewModel.isLoading && viewModel.questions.isEmpty {
                LoadingPlaceholderCard()
            } else if !viewModel.questions.isEmpty {
                QuestionsList(
                    questions: viewModel.questions,
                    openInputBox: {_ in }
                )
            } else if viewModel.router.currentTierStatus == .llamaModelNotPrompted {
                PermissionPromptCard(
                    runGeneration: viewModel.runGeneration,
                    startDownloadAndGenerate: viewModel.startDownloadAndGenerate
                )
            }

            if viewModel.errorMessage != nil {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }

        .task {
            if viewModel.router.currentTierStatus == .llamaModelNotPrompted {
                return
            }

            if viewModel.router.currentTierStatus == .llamaModelNeedsDownload {
                viewModel.startDownloadAndGenerate()
                return
            }
            await viewModel.runGeneration()
        }
    }
}
