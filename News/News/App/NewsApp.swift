import SwiftUI
import SwiftData

@main
struct NewsApp: App {

    // SwiftData container shared by the app and the widget extension
    // (use an App Group container ID if you want the widget to read the same cache)
    let modelContainer: ModelContainer = {
        let schema = Schema([CachedArticle.self, BookmarkedArticle.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject private var settings = SettingsViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(settings)
                .preferredColorScheme(settings.colorScheme)
        }
        .modelContainer(modelContainer)
    }
}
