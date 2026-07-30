import SwiftUI

/// Sits above ContentView. Shows the splash for a minimum duration OR until
/// initial data is ready (whichever is longer), then cross-fades into the
/// real app. This avoids two bad extremes: a splash that's gone before
/// anyone can read it, and a splash that lingers after the app is ready.
struct RootView: View {
    @State private var isActive = false
    @EnvironmentObject private var settings: SettingsViewModel

    /// Tune this — 1.2–1.8s reads as "polished" without feeling slow.
    private let minimumSplashDuration: Double = 5.0

    var body: some View {
        ZStack {
            if isActive {
                ContentView()
                    .transition(.opacity.combined(with: .scale(scale: 1.02)))
            } else {
                SplashScreenView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.45), value: isActive)
        .task {
            async let minimumDelay: Void = sleep(seconds: minimumSplashDuration)
            // Extend this with real warm-up work if you have any
            // (e.g. pre-fetching headlines, restoring auth session).
            // async let dataReady = someViewModel.preload()
            _ = await minimumDelay
            isActive = true
        }
    }

    private func sleep(seconds: Double) async {
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

#Preview {
    RootView()
        .environmentObject(SettingsViewModel())
        .modelContainer(for: [CachedArticle.self, BookmarkedArticle.self], inMemory: true)
}
