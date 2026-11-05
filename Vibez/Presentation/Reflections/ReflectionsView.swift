import SwiftUI

struct ReflectionsView: View {
    @State private var viewModel: ViewModel
    let movie: Movie

    init(
        repository: MovieRepositoryProtocol = Dependencies.shared.repository,
        movie: Movie,
        router: QuestionGenerationRoutingProtocol? = nil
    )
    {
        self.movie = movie
        _viewModel = State(
            initialValue: ViewModel(
                repository: repository,
                movie: movie,
                router: router
            )
        )
    }

    private var thoughtsIndex: Int? { viewModel.reflections.firstIndex(where: { $0.prompt == yourThoughtsPrompt})}


    var year: String {
        movie.releaseDate?.formatted(.dateTime.year()) ?? ""
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                /*
                 #if DEBUG
                 Button("Reset model states", role: .destructive) {
                 Task {
                 await viewModel.resetModelState()
                 }
                 }
                 #endif
                 */
                HStack( spacing: 10) {
                    MoviePosterWithFallback(posterPath: movie.posterPath, fades: false)
                        .frame(width: 60, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    VStack(alignment: .leading) {
                        Text(movie.title)
                        HStack {
                            Text(year)
                            Text("•")
                            Text(movie.genres.first?.name ?? "-")
                            Text("•")
                            Image(systemName: movie.adult ? "18.circle.fill" : "18.circle")
                                .foregroundStyle(movie.adult ? .red : .text)
                        }
                    }
                    Spacer()
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(.bgSecondary)
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.bgSecondaryLight, lineWidth: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Text("What stayed with you?")
                    .font(.title2)
                    .fontWeight(.semibold)

                if let index = thoughtsIndex {
                    ReflectionInput(
                        content: $viewModel.reflections[index].content,
                        isThoughtsInput: true,
                        prompt: yourThoughtsPrompt,
                        placehoder: "Start typing your thoughts here...",
                        updatedAt: viewModel.reflections[index].updatedAt
                    )
                    .onChange(of: viewModel.reflections[index].content) {_, _ in
                        viewModel.onContentChange(for: viewModel.reflections[index])
                    }
                }

                if viewModel.isDownloading {
                    DownloadProgressCard(downloandProgress: viewModel.downloadProgress)
                } else if viewModel.isLoading && viewModel.questions.isEmpty {
                    LoadingPlaceholderCard()
                } else if !viewModel.questions.isEmpty {
                    QuestionsList(
                        questions: viewModel.questions,
                        openInputBox: viewModel.openInputBox
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

                ForEach($viewModel.reflections) { $reflection in
                    if reflection.prompt != yourThoughtsPrompt {
                        ReflectionInput(
                            content: $reflection.content,
                            isThoughtsInput: false,
                            prompt: reflection.prompt,
                            placehoder: "Start typing here...",
                            updatedAt: reflection.updatedAt

                        )
                        .id(reflection.id)
                        .onChange(of: reflection.content) {_, _ in
                            viewModel.onContentChange(for: reflection)
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(
            ZStack(alignment: .top) {
                Color.black
                MoviePosterWithFallback(posterPath: movie.posterPath)
                    .opacity(0.15)
                    .frame(maxHeight: 50)
                    .ignoresSafeArea(edges: .top)
            }
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(alignment: .center, spacing: 4) {
                    Text("Reflection")
                        .font(.title2)

                    Text("Only visible to you.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }

        .task {
            await viewModel.fetchReflections()
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

#Preview {
    NavigationStack {
        ReflectionsView(
            repository: MockMovieRepository(),
            movie: Movie.mock,
            router: MockQuestionGenerationRouting()
        )
            .background(Color.background)
            .foregroundStyle(Color.text)
    }
}
