import SwiftUI

struct MovieListHorizontal: View {
    let movies: [Movie]
    let listTitle: String
    let navTitle: String
    let listDestination: TestView

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                HStack(alignment: .bottom ,spacing: 6) {
                    Text(listTitle)
                        .font(.title)
                    Text(String(movies.count))
                        .padding(14)
                        .background(Color.bgSecondaryLight)
                        .clipShape(Circle())
                }
                Spacer()
                NavigationLink(destination: listDestination) {
                    HStack {
                        Text(navTitle)
                        Image(systemName: "chevron.right")
                    }
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(movies) { movie in
                        MovieCardHorizontal(movie: movie)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, maxHeight: 160)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}


