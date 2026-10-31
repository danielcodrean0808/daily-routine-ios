import Combine
import Foundation
import SwiftUI

/// Holds the life goals and saves them to UserDefaults as JSON,
/// in the same way RoutineStore does for routine tasks.
final class GoalStore: ObservableObject {
    @Published var goals: [LifeGoal] = [] {
        didSet { save() }
    }

    private let goalsKey = "lifeGoals"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    /// Goals ordered critical, high, medium, low, then by title.
    var sortedGoals: [LifeGoal] {
        goals.sorted {
            if $0.priority.rank != $1.priority.rank {
                return $0.priority.rank > $1.priority.rank
            }
            return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }
    }

    func addGoal(_ goal: LifeGoal) {
        let trimmed = goal.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        var newGoal = goal
        newGoal.title = trimmed
        goals.append(newGoal)
    }

    func updateGoal(_ goal: LifeGoal) {
        guard let index = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        goals[index] = goal
    }

    func deleteGoal(_ id: UUID) {
        goals.removeAll { $0.id == id }
    }

    private func load() {
        guard let data = defaults.data(forKey: goalsKey),
              let decoded = try? JSONDecoder().decode([LifeGoal].self, from: data) else {
            return
        }
        goals = decoded
    }

    private func save() {
        if let data = try? JSONEncoder().encode(goals) {
            defaults.set(data, forKey: goalsKey)
        }
    }
}
