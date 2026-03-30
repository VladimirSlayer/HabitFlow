import Foundation

extension Notification.Name {
    static let habitsStoreDidUpdate = Notification.Name("habitsStoreDidUpdate")
}

final class HabitsStore {
    private enum Key {
        static let habits = "habitsStore.items"
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private(set) var habits: [HabitModel] {
        didSet {
            saveHabits()
            NotificationCenter.default.post(name: .habitsStoreDidUpdate, object: self)
        }
    }

    init(
        defaults: UserDefaults = .standard,
        defaultHabits: [HabitModel] = [
            HabitModel(id: UUID(), name: "Reading", colorHex: "#FF9500", completedToday: false),
            HabitModel(id: UUID(), name: "Workout", colorHex: "#34C759", completedToday: true),
            HabitModel(id: UUID(), name: "Water", colorHex: "#007AFF", completedToday: false)
        ]
    ) {
        self.defaults = defaults
        if let savedHabits = Self.loadHabits(from: defaults, using: decoder) {
            habits = savedHabits
        } else {
            habits = defaultHabits
            saveHabits()
        }
    }

    func addHabit(_ habit: HabitModel) {
        habits.append(habit)
    }

    func toggleHabitCompletion(id: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        habits[index].completedToday.toggle()
    }

    private func saveHabits() {
        guard let data = try? encoder.encode(habits) else { return }
        defaults.set(data, forKey: Key.habits)
    }

    private static func loadHabits(from defaults: UserDefaults, using decoder: JSONDecoder) -> [HabitModel]? {
        guard let data = defaults.data(forKey: Key.habits) else { return nil }
        return try? decoder.decode([HabitModel].self, from: data)
    }
}
