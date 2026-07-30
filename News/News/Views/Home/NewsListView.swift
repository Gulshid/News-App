import SwiftUI
import SwiftData

struct NewsListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = NewsViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CategoryScrollBar(selected: $viewModel.selectedCategory) { category in
                    Task { await viewModel.selectCategory(category) }
                }
                .padding(.vertical, 8)

                if viewModel.isShowingCachedData {
                    OfflineBanner()
                }

                content
            }
            .navigationTitle("Headlines")
            .task {
                viewModel.configureCache(context: modelContext)
                await viewModel.loadHeadlines()
            }
            .refreshable {
                await viewModel.loadHeadlines()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.articles.isEmpty {
            LoadingView()
        } else if let error = viewModel.errorMessage, viewModel.articles.isEmpty {
            ErrorStateView(message: error) {
                Task { await viewModel.loadHeadlines() }
            }
        } else {
            List(viewModel.articles) { article in
                NavigationLink(value: article) {
                    NewsRowView(article: article)
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: Article.self) { article in
                NewsDetailView(article: article)
            }
        }
    }
}

#Preview {
    NewsListView()
        .modelContainer(for: [CachedArticle.self, BookmarkedArticle.self], inMemory: true)
}
