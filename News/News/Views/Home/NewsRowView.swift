import SwiftUI

struct NewsRowView: View {
    let article: Article

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure, .empty:
                    Rectangle()
                        .fill(Color.secondary.opacity(0.15))
                        .overlay(Image(systemName: "photo").foregroundStyle(.secondary))
                @unknown default:
                    Rectangle().fill(Color.secondary.opacity(0.15))
                }
            }
            .frame(width: 90, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(3)

                Spacer(minLength: 0)

                HStack {
                    Text(article.source.name)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    Spacer()
                    Text(article.publishedAt, style: .relative)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
