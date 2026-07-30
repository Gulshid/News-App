import Foundation
import SwiftData

@MainActor
final class NewsViewModel: ObservableObject {

    @Published var articles: [Article] = []
    @Published var selectedCategory: NewsCategory = .general
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isShowingCachedData = false

    private let api: NewsAPIServicing
    private var cacheService: CacheService?
    let reachability = ReachabilityMonitor()

    init(api: NewsAPIServicing = NewsAPIService()) {
        self.api = api
    }

    /// Call once the SwiftData ModelContext is available from the environment.
    func configureCache(context: ModelContext) {
        cacheService = CacheService(context: context)
    }

    func loadHeadlines() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        guard reachability.isConnected else {
            loadFromCache()
            return
        }

        do {
            let fetched = try await api.fetchTopHeadlines(category: selectedCategory, country: "us")
            articles = fetched
            isShowingCachedData = false
            cacheService?.save(fetched, for: selectedCategory)
        } catch {
            // Network call failed even though we appear online (e.g. bad API key,
            // rate limit) — fall back to whatever we have cached.
            errorMessage = error.localizedDescription
            loadFromCache()
        }
    }

    func selectCategory(_ category: NewsCategory) async {
        guard category != selectedCategory else { return }
        selectedCategory = category
        await loadHeadlines()
    }

    private func loadFromCache() {
        guard let cached = cacheService?.loadCached(for: selectedCategory), !cached.isEmpty else {
            errorMessage = errorMessage ?? "No internet connection and no saved articles yet."
            return
        }
        articles = cached
        isShowingCachedData = true
    }
}
