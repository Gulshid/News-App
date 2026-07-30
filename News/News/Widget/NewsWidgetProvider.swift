import WidgetKit

/// This file lives in a separate Widget Extension target in Xcode.
/// See the README for step-by-step instructions on creating that target
/// and sharing code/data with the main app via an App Group.

struct HeadlineEntry: TimelineEntry {
    let date: Date
    let title: String
    let sourceName: String
    let imageURL: String?
}

struct NewsWidgetProvider: TimelineProvider {

    func placeholder(in context: Context) -> HeadlineEntry {
        HeadlineEntry(date: .now, title: "Top headline loading…", sourceName: "News App", imageURL: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (HeadlineEntry) -> Void) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HeadlineEntry>) -> Void) {
        Task {
            let entry = await fetchLatestEntry()
            // Refresh every 30 minutes.
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: .now) ?? .now
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }

    private func fetchLatestEntry() async -> HeadlineEntry {
        do {
            let api = NewsAPIService()
            let articles = try await api.fetchTopHeadlines(category: .general, country: "us")
            if let first = articles.first {
                return HeadlineEntry(
                    date: .now,
                    title: first.title,
                    sourceName: first.source.name,
                    imageURL: first.urlToImage
                )
            }
        } catch {
            // Fall through to a placeholder entry on failure (e.g. offline).
        }
        return HeadlineEntry(date: .now, title: "Couldn't load the latest headline", sourceName: "News App", imageURL: nil)
    }
}
