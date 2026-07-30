import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $settings.appearance) {
                        ForEach(AppearanceOption.allCases) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("About") {
                    LabeledContent("Data source", value: "NewsAPI.org")
                    LabeledContent("Offline cache", value: "Enabled")
                    Text("Headlines are cached on-device so you can keep reading recent articles without a connection. A Home Screen widget shows the latest top headline.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
