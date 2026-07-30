import SwiftUI
import SwiftData

struct NewsDetailView: View {
    let article: Article

    @Environment(\.modelContext) private var modelContext
    @StateObject private var bookmarksVM = BookmarksViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: article.urlToImage ?? "")) { phase in
                    if case .success(let image) = phase {
                        image.resizable().aspectRatio(contentMode: .fill)
                    } else {
                        Rectangle().fill(Color.secondary.opacity(0.15))
                    }
                }
                .frame(height: 220)
                .clipped()

                VStack(alignment: .leading, spacing: 10) {
                    Text(article.title)
                        .font(.title2.weight(.bold))

                    HStack {
                        Text(article.source.name)
                            .font(.subheadline.weight(.medium))
                        if let author = article.author {
                            Text("· \(author)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Text(article.formattedDate)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Divider()

                    if let description = article.description {
                        Text(description)
                            .font(.body)
                    }
                    if let content = article.content {
                        Text(content)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    if let urlString = article.url, let url = URL(string: urlString) {
                        Link(destination: url) {
                            Label("Read full article", systemImage: "safari")
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    bookmarksVM.toggle(article)
                } label: {
                    Image(systemName: bookmarksVM.isBookmarked(article) ? "bookmark.fill" : "bookmark")
                }
            }
            if let urlString = article.url, let url = URL(string: urlString) {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: url)
                }
            }
        }
        .onAppear {
            bookmarksVM.configure(context: modelContext)
        }
    }
}
