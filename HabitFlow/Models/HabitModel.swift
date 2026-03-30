import Foundation

struct HabitModel: Identifiable {
    let id: UUID
    let name: String
    let colorHex: String
    let completedToday: Bool
}
