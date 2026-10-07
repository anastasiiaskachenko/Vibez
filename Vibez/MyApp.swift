import SwiftUI

@main struct MyApp: App {
    init() {
        Task {
            do {
                try await testTMDBCalls()
            } catch {
                print("tests failed")
            }
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
