import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NewsListView()
                .tabItem { Label("Headlines", systemImage: "newspaper") }

            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }

            BookmarksView()
                .tabItem { Label("Bookmarks", systemImage: "bookmark") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}

#Preview {
    ContentViewPreviewWrapper()
}

private struct ContentViewPreviewWrapper: View {
    @StateObject private var settings = SettingsViewModel()

    var body: some View {
        ContentView()
            .environmentObject(settings)
            .modelContainer(for: [CachedArticle.self, BookmarkedArticle.self], inMemory: true)
            .preferredColorScheme(settings.colorScheme)
    }
}
