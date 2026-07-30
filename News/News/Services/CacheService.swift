import Foundation
import SwiftData

/// Handles reading/writing the offline article cache. Kept separate from
/// the view model so it can be unit-tested and reused by the widget.
@MainActor
final class CacheService {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func save(_ articles: [Article], for category: NewsCategory) {
        // Clear out this category's old cache before writing the fresh batch.
        let categoryRaw = category.rawValue
        let descriptor = FetchDescriptor<CachedArticle>(
            predicate: #Predicate { $0.category == categoryRaw }
        )
        if let stale = try? context.fetch(descriptor) {
            stale.forEach { context.delete($0) }
        }

        for article in articles {
            context.insert(CachedArticle(from: article, category: category.rawValue))
        }
        try? context.save()
    }

    func loadCached(for category: NewsCategory) -> [Article] {
        let categoryRaw = category.rawValue
        let descriptor = FetchDescriptor<CachedArticle>(
            predicate: #Predicate { $0.category == categoryRaw },
            sortBy: [SortDescriptor(\.publishedAt, order: .reverse)]
        )
        let cached = (try? context.fetch(descriptor)) ?? []
        return cached.map { $0.asArticle }
    }
}
