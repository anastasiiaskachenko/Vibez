import SwiftUI

struct ContentView: View {
    @State private var viewModel: ViewModel?
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()

                Group {
                    if let viewModel {
                        GenresView(viewModel: GenresView.ViewModel(repository: viewModel.repository))
                    } else if let errorMessage {
                        // TODO: replace with ContentUnavailableView
                        TestView()
                    } else {
                        // TODO: replace with progress view
                        TestView()
                    }
                }
            }
        }
        .task {
            do {
                self.viewModel = try ViewModel()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
