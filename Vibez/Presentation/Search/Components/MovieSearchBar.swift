import SwiftUI

struct MovieSearchBar: View {
    @Binding var searchQuery: String
    var onQueryChange: (String) -> Void
    var isFocused: FocusState<Bool>.Binding

    var body: some View {
        HStack(spacing: 8) {
            TextField("Start typing here...", text: $searchQuery)
                .onChange(of: searchQuery) {_, newValue in
                    onQueryChange(newValue)
                }
                .focused(isFocused)
            Button {
                isFocused.wrappedValue = false
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.accent)
            }
        }
        .padding(16)
        .background(Color.bgSecondary)
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.bgSecondaryLight, lineWidth: 2)

        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
