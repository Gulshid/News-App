import Foundation
import Network

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(String)
    case decodingFailed
    case apiError(String)
    case offline

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .requestFailed(let message): return message
        case .decodingFailed: return "Couldn't read the server's response."
        case .apiError(let message): return message
        case .offline: return "You're offline. Showing saved articles."
        }
    }
}

/// Lightweight wrapper around NWPathMonitor so views/view models can
/// observe connectivity as a published boolean.
@MainActor
final class ReachabilityMonitor: ObservableObject {
    @Published private(set) var isConnected = true

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ReachabilityMonitor")

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
