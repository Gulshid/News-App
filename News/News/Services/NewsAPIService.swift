import Foundation

protocol NewsAPIServicing {
    func fetchTopHeadlines(category: NewsCategory, country: String) async throws -> [Article]
    func search(query: String) async throws -> [Article]
}

final class NewsAPIService: NewsAPIServicing {

    private let baseURL = "https://newsapi.org/v2"
    private let session: URLSession
    private let apiKey: String

    init(apiKey: String = Secrets.newsAPIKey, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    func fetchTopHeadlines(category: NewsCategory, country: String = "us") async throws -> [Article] {
        var components = URLComponents(string: "\(baseURL)/top-headlines")
        components?.queryItems = [
            URLQueryItem(name: "category", value: category.rawValue),
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "pageSize", value: "30"),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        return try await perform(components)
    }

    func search(query: String) async throws -> [Article] {
        var components = URLComponents(string: "\(baseURL)/everything")
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sortBy", value: "publishedAt"),
            URLQueryItem(name: "pageSize", value: "30"),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        return try await perform(components)
    }

    private func perform(_ components: URLComponents?) async throws -> [Article] {
        guard let url = components?.url else { throw NetworkError.invalidURL }

        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.requestFailed("No response from server.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard http.statusCode == 200 else {
            if let apiError = try? decoder.decode(NewsAPIErrorPayload.self, from: data) {
                throw NetworkError.apiError(apiError.message)
            }
            throw NetworkError.requestFailed("Server returned status \(http.statusCode).")
        }

        do {
            let decoded = try decoder.decode(NewsResponse.self, from: data)
            return decoded.articles
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}

private struct NewsAPIErrorPayload: Codable {
    let status: String
    let code: String?
    let message: String
}
