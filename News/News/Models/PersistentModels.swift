import Foundation
import SwiftData

/// Stores the most recently fetched headlines so the app has something
/// to show when there is no network connection.
@Model
final class CachedArticle {
    @Attribute(.unique) var url: String
    var title: String
    var articleDescription: String?
    var author: String?
    var sourceName: String
    var imageURL: String?
    var publishedAt: Date
    var content: String?
    var category: String
    var fetchedAt: Date

    init(from article: Article, category: String) {
        self.url = article.url ?? UUID().uuidString
        self.title = article.title
        self.articleDescription = article.description
        self.author = article.author
        self.sourceName = article.source.name
        self.imageURL = article.urlToImage
        self.publishedAt = article.publishedAt
        self.content = article.content
        self.category = category
        self.fetchedAt = .now
    }

    var asArticle: Article {
        Article(
            source: ArticleSource(id: nil, name: sourceName),
            author: author,
            title: title,
            description: articleDescription,
            url: url,
            urlToImage: imageURL,
            publishedAt: publishedAt,
            content: content
        )
    }
}

/// User-saved articles for the Bookmarks tab. Kept separate from the
/// rolling cache so bookmarks never get evicted.
@Model
final class BookmarkedArticle {
    @Attribute(.unique) var url: String
    var title: String
    var articleDescription: String?
    var author: String?
    var sourceName: String
    var imageURL: String?
    var publishedAt: Date
    var content: String?
    var savedAt: Date

    init(from article: Article) {
        self.url = article.url ?? UUID().uuidString
        self.title = article.title
        self.articleDescription = article.description
        self.author = article.author
        self.sourceName = article.source.name
        self.imageURL = article.urlToImage
        self.publishedAt = article.publishedAt
        self.content = article.content
        self.savedAt = .now
    }

    var asArticle: Article {
        Article(
            source: ArticleSource(id: nil, name: sourceName),
            author: author,
            title: title,
            description: articleDescription,
            url: url,
            urlToImage: imageURL,
            publishedAt: publishedAt,
            content: content
        )
    }
}
