import Foundation

/// A personal life goal with a category, a priority and a progress percentage.
struct LifeGoal: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var description: String?
    var category: GoalCategory
    var priority: Priority
    /// Progress from 0 to 100.
    var progress: Double = 0
    var targetDate: Date?
    var createdDate = Date()

    enum GoalCategory: String, Codable, CaseIterable {
        case personal, health, career, education, finance, relationships, other
    }

    enum Priority: String, Codable, CaseIterable {
        case low, medium, high, critical

        /// Higher numbers are more important. Used for sorting.
        var rank: Int {
            switch self {
            case .low: return 0
            case .medium: return 1
            case .high: return 2
            case .critical: return 3
            }
        }
    }
}
