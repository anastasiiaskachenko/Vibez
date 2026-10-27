import SwiftUI

struct GenresView: View {
    @State private var viewModel: ViewModel

    init(repository: MovieRepositoryProtocol = Dependencies.shared.repository) {
        _viewModel = State(initialValue: ViewModel(repository: repository))
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("VIBEZ")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.accent)
                Text("Choose the vibe of today:")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if viewModel.isLoading && viewModel.genres.isEmpty {
                ProgressView()
                    .frame(maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView(
                    "Failed to load genres",
                    systemImage: "wifi.exclamationmark",
                    description: Text(errorMessage)
                )
            } else {
                ScrollView {
                    GenresList(genres: viewModel.genres)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .background(Color.background)
        .foregroundStyle(Color.text)
        .task {
            await viewModel.loadGenres()
        }
    }
}
