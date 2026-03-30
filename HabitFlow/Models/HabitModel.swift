import Foundation

struct HabitModel: Identifiable, Codable {
    let id: UUID
    let name: String
    let colorHex: String
    var completedToday: Bool
}
