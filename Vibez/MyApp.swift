import SwiftUI
import SwiftData

@main struct MyApp: App {
    init() {
        Task {
            do {
                try testSwiftDataDiskStorage()
            } catch {
                print("Failed to test swift data \(error)")
            }
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
