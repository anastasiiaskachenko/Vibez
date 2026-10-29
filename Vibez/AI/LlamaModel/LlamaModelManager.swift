import Foundation

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

    func downloadModel(progressHandler: (@Sendable (Double) -> Void)? = nil) async throws -> URL {
        if isModelReady {
            print("[Fallback model] File already exists at \(localModelURL.path)")
            return localModelURL
        }

        print("[Fallback model] Starting download from: \(remoteURL)")

        let session = URLSession(configuration: .default)
        let (asyncBytes, response) = try await session.bytes(from: remoteURL)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let expectedLength = response.expectedContentLength
        var downloadedBytes: Int64 = 0

        let tempDestination = localModelURL.appendingPathExtension("tmp")
        if FileManager.default.fileExists(atPath: tempDestination.path) {
            try? FileManager.default.removeItem(at: tempDestination)
        }

        FileManager.default.createFile(atPath: tempDestination.path, contents: nil)
        let fileHandle = try FileHandle(forWritingTo: tempDestination)
        defer { try? fileHandle.close() }

        var buffer = Data()
        let chunkSize = 1024 * 1024

        for try await byte in asyncBytes {
            buffer.append(byte)
            downloadedBytes += 1

            if buffer.count >= chunkSize {
                try fileHandle.write(contentsOf: buffer)
                buffer.removeAll(keepingCapacity: true)

                if expectedLength > 0 && progressHandler != nil {
                    let progress = Double(downloadedBytes) / Double(expectedLength)
                    progressHandler?(progress)
                }
            }
        }

        if !buffer.isEmpty {
            try fileHandle.write(contentsOf: buffer)
        }

        if FileManager.default.fileExists(atPath: localModelURL.path) {
            try FileManager.default.removeItem(at: localModelURL)
        }

        try FileManager.default.moveItem(at: tempDestination, to: localModelURL)

        print("[Fallback model] Download complete! Saved to \(localModelURL.path)")
        return localModelURL
    }

    func deleteModel() throws {
        let tmpURL = localModelURL.appendingPathExtension("tmp")

        if FileManager.default.fileExists(atPath: tmpURL.path) {
            try? FileManager.default.removeItem(at: tmpURL)
        }

        if FileManager.default.fileExists(atPath: localModelURL.path) {
            try FileManager.default.removeItem(at: localModelURL)
            print("[Fallback model] Removed local model.")
        } else {
            print("[Fallback model] no file to delete at \(localModelURL.path)")
        }
    }
}
