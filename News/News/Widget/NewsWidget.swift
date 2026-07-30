import SwiftUI
import WidgetKit

struct NewsWidgetEntryView: View {
    var entry: HeadlineEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Top Headline", systemImage: "newspaper.fill")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.secondary)

            Text(entry.title)
                .font(family == .systemSmall ? .caption : .headline)
                .fontWeight(.semibold)
                .lineLimit(family == .systemSmall ? 4 : 3)

            Spacer()

            Text(entry.sourceName)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(.background, for: .widget)
    }
}

struct NewsWidget: Widget {
    let kind = "NewsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NewsWidgetProvider()) { entry in
            NewsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Top Headline")
        .description("Shows the latest top news headline.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    NewsWidget()
} timeline: {
    HeadlineEntry(date: .now, title: "Sample breaking news headline goes here", sourceName: "News App", imageURL: nil)
}
