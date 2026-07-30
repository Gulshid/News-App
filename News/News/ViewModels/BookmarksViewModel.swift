import Foundation
import SwiftData

@MainActor
final class BookmarksViewModel: ObservableObject {

    @Published var bookmarks: [BookmarkedArticle] = []
    private var context: ModelContext?

    func configure(context: ModelContext) {
        self.context = context
        refresh()
    }

    func refresh() {
        guard let context else { return }
        let descriptor = FetchDescriptor<BookmarkedArticle>(
            sortBy: [SortDescriptor(\.savedAt, order: .reverse)]
        )
        bookmarks = (try? context.fetch(descriptor)) ?? []
    }

    func isBookmarked(_ article: Article) -> Bool {
        bookmarks.contains { $0.url == article.url }
    }

    func toggle(_ article: Article) {
        guard let context else { return }
        if let existing = bookmarks.first(where: { $0.url == article.url }) {
            context.delete(existing)
        } else {
            context.insert(BookmarkedArticle(from: article))
        }
        try? context.save()
        refresh()
    }

    func delete(at offsets: IndexSet) {
        guard let context else { return }
        offsets.map { bookmarks[$0] }.forEach { context.delete($0) }
        try? context.save()
        refresh()
    }
}
