import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.query.isEmpty {
                    ContentUnavailableView(
                        "Search News",
                        systemImage: "magnifyingglass",
                        description: Text("Find articles by keyword, topic, or company.")
                    )
                } else if viewModel.isLoading {
                    LoadingView()
                } else if let error = viewModel.errorMessage {
                    ErrorStateView(message: error) { viewModel.queryChanged() }
                } else if viewModel.results.isEmpty {
                    ContentUnavailableView.search(text: viewModel.query)
                } else {
                    List(viewModel.results) { article in
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
            .navigationTitle("Search")
            .searchable(text: $viewModel.query, prompt: "Search articles")
            .onChange(of: viewModel.query) {
                viewModel.queryChanged()
            }
        }
    }
}
