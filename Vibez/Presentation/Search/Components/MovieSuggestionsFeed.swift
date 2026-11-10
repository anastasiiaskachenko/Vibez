import SwiftUI

struct MovieSuggestionsFeed: View {
    let isLoading: Bool
    let errorMessage: String?
    let movies: [Movie]
    var onDismissKeyBoard: () -> Void

    var body: some View {
        if isLoading && movies.isEmpty {
            ProgressView()
                .frame(maxHeight: .infinity)
        } else if let errorMessage = errorMessage,
                 movies.isEmpty {
           ContentUnavailableView(
               "Failed to load movies",
               systemImage: "wifi.exclamationmark",
               description: Text(errorMessage)
           )
       } else if movies.isEmpty {
            ContentUnavailableView(
                "No movies match your search, try different key words.",
                systemImage: "film"
            )
        } else {
            ScrollView {
                MovieFeed(movies: movies, loadMore: {})
            }
            .contentMargins(.top, 0, for: .scrollContent)
            .simultaneousGesture(
                DragGesture().onChanged { _ in
                    onDismissKeyBoard()
                }
            )
            .scrollDismissesKeyboard(.interactively)
        }
    }
}
