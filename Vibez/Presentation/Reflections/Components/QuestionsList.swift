import SwiftUI

struct QuestionsList: View {
    let questions: [String]
    let openInputBox: (String) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(questions, id: \.self) {question in
                    Button {
                        openInputBox(question)
                    } label: {
                        Text(question)
                            .padding(8)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.secondary, lineWidth: 4)
                            )
                    }
                }
            }
        }
    }
}
