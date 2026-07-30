import Foundation

/// Maps to a single article returned by NewsAPI.org
struct Article: Codable, Identifiable, Hashable {
    var id: String { (url ?? UUID().uuidString) }

    let source: ArticleSource
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date
    let content: String?

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: publishedAt)
    }
}

struct ArticleSource: Codable, Hashable {
    let id: String?
    let name: String
}

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int?
    let articles: [Article]
}

enum NewsCategory: String, CaseIterable, Identifiable {
    case general, business, technology, entertainment, health, science, sports

    var id: String { rawValue }

    var displayName: String { rawValue.capitalized }

    var symbol: String {
        switch self {
        case .general: return "newspaper"
        case .business: return "chart.line.uptrend.xyaxis"
        case .technology: return "cpu"
        case .entertainment: return "film"
        case .health: return "heart.text.square"
        case .science: return "atom"
        case .sports: return "sportscourt"
        }
    }
}
