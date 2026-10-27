import SwiftUI
import Kingfisher
import Playgrounds

struct MoviePosterWithFallback: View {
    let posterPath: URL?
    var fades: Bool = true
    var body: some View {
        KFImage(posterPath)
            .placeholder {
                ZStack {
                    Color.background
                    ProgressView()
                }
            }
            .onFailureView {
                Image("notFound")
                    .resizable()
                    .scaledToFill()
            }
            .onFailure { error in
                print("Failed to load image \(error)")
            }
            .resizable()
            .scaledToFill()
            .clipped()
            .if(fades) { view in
                view.mask(
                    LinearGradient(stops:
                                    [
                                        .init(color: .black, location: 0.0),
                                        .init(color: .black, location: 0.6),
                                        .init(color: .clear, location: 0.97)
                                    ],
                                   startPoint: .top,
                                   endPoint: .bottom
                                  )
                )
            }
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }

    }
}

#Preview {
    MoviePosterWithFallback(posterPath: URL(string: "https://image.tmdb.org/t/p/w500/jSziioSwPVrOy9Yow3XhWIBDjq1.jpg"))
}
