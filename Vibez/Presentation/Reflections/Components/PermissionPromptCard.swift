import SwiftUI

struct PermissionPromptCard: View {
    let runGeneration: () async -> Void
    let startDownloadAndGenerate: () async -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Apple Intelligence is not available on this device.")
                .font(.footnote)

            Text("Download our compact AI model (~980 MB) to generate questions locally (offline as well)")

            HStack(spacing: 12) {
                Button("Use Remote Model") {
                    UserDefaults.standard.set(false, forKey: "isLlamaModelApproved")
                    Task { await runGeneration() }
                }
                .buttonStyle(.bordered)
                Button("Download (~980 MB)") {
                    UserDefaults.standard.set(true, forKey: "isLlamaModelApproved")
                    Task { await startDownloadAndGenerate() }
                }
            }
        }
        .padding(16)
    }
}
