import Foundation

extension Notification.Name {
    static let habitsStoreDidUpdate = Notification.Name("habitsStoreDidUpdate")
}

final class HabitsStore {
    private(set) var habits: [HabitModel] {
        didSet {
            NotificationCenter.default.post(name: .habitsStoreDidUpdate, object: self)
        }
    }

    init(habits: [HabitModel] = [
        HabitModel(id: UUID(), name: "Reading", colorHex: "#FF9500", completedToday: false),
        HabitModel(id: UUID(), name: "Workout", colorHex: "#34C759", completedToday: true),
        HabitModel(id: UUID(), name: "Water", colorHex: "#007AFF", completedToday: false)
    ]) {
        self.habits = habits
    }

    func addHabit(_ habit: HabitModel) {
        habits.append(habit)
    }

    func toggleHabitCompletion(id: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        habits[index].completedToday.toggle()
    }
}
