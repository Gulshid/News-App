import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Loading news…")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ErrorStateView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)
            Button("Try Again", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct OfflineBanner: View {
    var body: some View {
        Label("Showing saved articles — you're offline", systemImage: "wifi.slash")
            .font(.caption.weight(.medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(Color.orange.opacity(0.15))
            .foregroundStyle(.orange)
    }
}
