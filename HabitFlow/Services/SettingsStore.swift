import Foundation

final class SettingsStore {
    private enum Key {
        static let dailyRemindersEnabled = "dailyRemindersEnabled"
        static let cozySoundsEnabled = "cozySoundsEnabled"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        registerDefaultsIfNeeded()
    }

    var dailyRemindersEnabled: Bool {
        get { defaults.bool(forKey: Key.dailyRemindersEnabled) }
        set { defaults.set(newValue, forKey: Key.dailyRemindersEnabled) }
    }

    var cozySoundsEnabled: Bool {
        get { defaults.bool(forKey: Key.cozySoundsEnabled) }
        set { defaults.set(newValue, forKey: Key.cozySoundsEnabled) }
    }

    var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }

    var buildNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }

    private func registerDefaultsIfNeeded() {
        defaults.register(defaults: [
            Key.dailyRemindersEnabled: true,
            Key.cozySoundsEnabled: false
        ])
    }
}
