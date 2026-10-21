import Foundation

struct RoutineTask: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var isDone = false
}
