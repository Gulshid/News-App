import SwiftUI

struct CategoryChipView: View {
    let category: NewsCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(category.displayName, systemImage: category.symbol)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color.secondary.opacity(0.15))
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct CategoryScrollBar: View {
    @Binding var selected: NewsCategory
    let onSelect: (NewsCategory) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(NewsCategory.allCases) { category in
                    CategoryChipView(category: category, isSelected: category == selected) {
                        onSelect(category)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
