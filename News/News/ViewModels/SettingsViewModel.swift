import SwiftUI
import Combine

enum AppearanceOption: String, CaseIterable, Identifiable {
    case system, light, dark
    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }
}

final class SettingsViewModel: ObservableObject {

    @AppStorage("appearanceOption") private var storedAppearance: String = AppearanceOption.system.rawValue

    @Published var appearance: AppearanceOption = .system {
        didSet { storedAppearance = appearance.rawValue }
    }

    init() {
        appearance = AppearanceOption(rawValue: storedAppearance) ?? .system
    }

    var colorScheme: ColorScheme? {
        switch appearance {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
