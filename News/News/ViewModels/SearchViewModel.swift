import Foundation

@MainActor
final class SearchViewModel: ObservableObject {

    @Published var query = ""
    @Published var results: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let api: NewsAPIServicing
    private var searchTask: Task<Void, Never>?

    init(api: NewsAPIServicing = NewsAPIService()) {
        self.api = api
    }

    /// Debounces so we don't fire a network request on every keystroke.
    func queryChanged() {
        searchTask?.cancel()
        let currentQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !currentQuery.isEmpty else {
            results = []
            errorMessage = nil
            return
        }

        searchTask = Task {
            try? await Task.sleep(nanoseconds: 400_000_000)
            guard !Task.isCancelled else { return }
            await performSearch(currentQuery)
        }
    }

    private func performSearch(_ text: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            results = try await api.search(query: text)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
