import SwiftUI
import SwiftData

struct BookmarksView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = BookmarksViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.bookmarks.isEmpty {
                    ContentUnavailableView(
                        "No Bookmarks Yet",
                        systemImage: "bookmark",
                        description: Text("Tap the bookmark icon on any article to save it here.")
                    )
                } else {
                    List {
                        ForEach(viewModel.bookmarks) { saved in
                            NavigationLink(value: saved.asArticle) {
                                NewsRowView(article: saved.asArticle)
                            }
                        }
                        .onDelete(perform: viewModel.delete)
                    }
                    .listStyle(.plain)
                    .navigationDestination(for: Article.self) { article in
                        NewsDetailView(article: article)
                    }
                }
            }
            .navigationTitle("Bookmarks")
            .onAppear {
                viewModel.configure(context: modelContext)
            }
        }
    }
}
