import Foundation
import Synchronization

actor LlamaModelManager {
    static let shared = LlamaModelManager()

    let modelFileName = "qwen2.5-1.5b-instruct-q4_k_m.gguf"
    let remoteURL = URL(string:
        """
        https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF/resolve/main/qwen2.5-1.5b-instruct-q4_k_m.gguf
        """
    )!

    var localModelURL: URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("Models", isDirectory: true)

        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir.appendingPathComponent(modelFileName)
    }

    var isModelReady: Bool {
        guard FileManager.default.fileExists(atPath: localModelURL.path) else { return false }

        if let attributes = try? FileManager.default.attributesOfItem(atPath: localModelURL.path),
           let size = attributes[.size] as? Int64 {
            return size > 500_000_000
        }

        return false
    }

    private var downloadTask: Task<URL, Error>?

    func downloadModel(progressHandler: (@Sendable (Double) -> Void)? = nil) async throws -> URL {
        if isModelReady {
            print("[Fallback model] File already exists at \(localModelURL.path)")
            return localModelURL
        }

        if let downloadTask { return try await downloadTask.value}

        let task = Task {
            let delegate = progressHandler.map(DownloadProgressDelegate.init)

            // The system streams the response straight to a temporary file and returns its location.
            let (tempFileURL, response) = try await URLSession.shared.download(from: remoteURL, delegate: delegate)

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                try? FileManager.default.removeItem(at: tempFileURL)
                throw URLError(.badServerResponse)
            }

            if FileManager.default.fileExists(atPath: localModelURL.path) {
                try FileManager.default.removeItem(at: localModelURL)
            }

            try FileManager.default.moveItem(at: tempFileURL, to: localModelURL)
            var url = localModelURL

            //var values = URLResourceValues()
            //values.isExcludedFromBackup = true
            //try url.resourceValues(values)

            return url
        }

        downloadTask = task
        defer { downloadTask = nil }
        return try await task.value



        return localModelURL
    }

    func deleteModel() throws {
        let tmpURL = localModelURL.appendingPathExtension("tmp")

        if FileManager.default.fileExists(atPath: tmpURL.path) {
            try? FileManager.default.removeItem(at: tmpURL)
        }

        if FileManager.default.fileExists(atPath: localModelURL.path) {
            try FileManager.default.removeItem(at: localModelURL)
        }
    }
}

nonisolated private final class DownloadProgressDelegate: NSObject, URLSessionTaskDelegate, Sendable {
    private let progressHandler: @Sendable (Double) -> Void
    private let state = Mutex<(observation: NSKeyValueObservation?, lastPercent: Int)>((nil, -1))

    init(progressHandler: @escaping @Sendable (Double) -> Void) {
        self.progressHandler = progressHandler
    }

    func urlSession(_ session: URLSession, didCreateTask task: URLSessionTask) {
        let observation = task.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
            self?.report(progress.fractionCompleted)
        }
        state.withLock { $0.observation = observation }
    }

    private func report(_ fraction: Double) {
        let percent = Int(fraction * 100)
        let isNewPercent = state.withLock { state in
            guard percent > state.lastPercent else { return false }
            state.lastPercent = percent
            return true
        }
        if isNewPercent {
            progressHandler(fraction)
        }
    }
}
