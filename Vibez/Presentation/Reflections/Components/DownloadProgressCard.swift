import SwiftUI

struct DownloadProgressCard: View {
    let downloandProgress: Double
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Downloading local model for offline use...")
                .font(.caption)
            ProgressView(value: downloandProgress, total: 1.0)
            Text("\(Int(downloandProgress * 100))%")
                .font(.caption2)
        }
        .padding(16)
    }
}
