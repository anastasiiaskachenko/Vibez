import SwiftUI

struct GenresView: View {
    @State var viewModel: ViewModel
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
            .padding(.horizontal, 24)
            ScrollView {
                GenresList(viewModel: viewModel)
            }
        }
        .task {
            await viewModel.loadGenres()
        }
    }
}
