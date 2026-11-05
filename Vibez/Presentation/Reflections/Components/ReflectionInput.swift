import SwiftUI

struct ReflectionInput: View {
    @Binding var content: String
    var isThoughtsInput: Bool
    var prompt: String
    var placehoder: String
    var updatedAt: Date

    var body: some View {
        VStack(alignment: .leading) {
            Text(prompt)
                .fontWeight(.semibold)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $content)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, isThoughtsInput ? 0 : 4)
                    .padding(.vertical, isThoughtsInput ? 0 : 4)
                    .background(isThoughtsInput ? .bgSecondary : .bgSecondaryLight)
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                if content.isEmpty {
                    HStack {
                        Text(placehoder)
                            .font(.body)
                            .foregroundStyle(.textSecondary)
                            .padding(.horizontal, isThoughtsInput ? 4 : 10)
                            .padding(.vertical, isThoughtsInput ? 6 : 12)
                            .allowsHitTesting(false)
                        Spacer()
                        Image(systemName: "pencil")
                    }
                    .padding(.trailing, 4)
                }
            }
            TimelineView(.periodic(from: .now, by: 60.0)) { _ in
                Text("Last updated \(updatedAt.formatted(.relative(presentation: .named)))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(.bgSecondary)
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.bgSecondaryLight, lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
