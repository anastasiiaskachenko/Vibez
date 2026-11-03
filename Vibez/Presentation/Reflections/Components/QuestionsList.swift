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
                        HStack{
                            Image(systemName: "sparkles")
                            Text(question)
                        }
                    }
                    .buttonStyle(.primaryAction)
                }
            }
            .padding(6)
        }
    }
}

#Preview {
    QuestionsList(questions: ["first question", "second question", "third very very very very long question"], openInputBox: {_ in })
}
