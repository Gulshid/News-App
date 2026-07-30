import SwiftUI

/// A branded animated splash screen shown for a couple seconds at cold
/// launch, before handing off to the real app content.
///
/// Design notes:
/// - Uses a subtle gradient background instead of flat white/black so it
///   reads as "designed" rather than a placeholder.
/// - Logo animates in with a spring (scale + fade) instead of just appearing.
/// - A thin progress indicator communicates the app is doing real work
///   (fetching headlines) rather than just padding time artificially.
/// - Respects Dark Mode automatically via semantic colors.
struct SplashScreenView: View {
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0
    @State private var taglineOpacity: Double = 0
    @State private var backgroundRotation: Double = 0

    var body: some View {
        ZStack {
            // Animated gradient backdrop
            AngularGradient(
                gradient: Gradient(colors: [
                    Color.accentColor.opacity(0.85),
                    Color.accentColor.opacity(0.4),
                    Color.accentColor.opacity(0.85)
                ]),
                center: .center,
                angle: .degrees(backgroundRotation)
            )
            .blur(radius: 60)
            .ignoresSafeArea()
            .background(Color(.systemBackground))

            VStack(spacing: 18) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 120, height: 120)
                        .shadow(color: .black.opacity(0.15), radius: 20, y: 10)

                    Image(systemName: "newspaper.fill")
                        .font(.system(size: 52, weight: .semibold))
                        .foregroundStyle(.white, Color.accentColor)
                        .symbolRenderingMode(.palette)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                Text("News")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .opacity(logoOpacity)

                Text("Stay informed, effortlessly")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .opacity(taglineOpacity)

                Spacer()

                ProgressView()
                    .progressViewStyle(.circular)
                    .opacity(taglineOpacity)
                    .padding(.bottom, 48)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.65)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeIn(duration: 0.5).delay(0.35)) {
                taglineOpacity = 1.0
            }
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                backgroundRotation = 360
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
