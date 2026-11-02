import Foundation

func parseLLMResponseBody(responseBody: String) -> [String] {
    return responseBody.components(separatedBy: .newlines)
    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
    .map { line in
        line.replacingOccurrences(of: "^[-*•\\d.]+\\s*", with: "", options: .regularExpression)
    }
    .filter { line in
        !line.isEmpty && line.count > 10 && !line.contains("<|im_")
    }
}
