import Combine
import Foundation
import SwiftUI

/// Holds the routine tasks and saves them to UserDefaults as JSON.
/// Ticks are cleared automatically when a new day starts.
final class RoutineStore: ObservableObject {
    @Published var tasks: [RoutineTask] = [] {
        didSet { save() }
    }

    private let tasksKey = "routineTasks"
    private let lastResetKey = "lastResetDate"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
        resetIfNewDay()
    }

    var doneCount: Int {
        tasks.filter { $0.isDone }.count
    }

    func add(_ title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        tasks.append(RoutineTask(title: trimmed))
    }

    func toggle(_ task: RoutineTask) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isDone.toggle()
    }

    func delete(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    func move(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
    }

    func resetIfNewDay() {
        let today = Calendar.current.startOfDay(for: Date())
        if let last = defaults.object(forKey: lastResetKey) as? Date,
           Calendar.current.isDate(last, inSameDayAs: today) {
            return
        }
        for index in tasks.indices {
            tasks[index].isDone = false
        }
        defaults.set(today, forKey: lastResetKey)
    }

    private func load() {
        guard let data = defaults.data(forKey: tasksKey),
              let decoded = try? JSONDecoder().decode([RoutineTask].self, from: data) else {
            return
        }
        tasks = decoded
    }

    private func save() {
        if let data = try? JSONEncoder().encode(tasks) {
            defaults.set(data, forKey: tasksKey)
        }
    }
}
