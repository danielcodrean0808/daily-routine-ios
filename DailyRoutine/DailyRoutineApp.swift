import SwiftUI

@main
struct DailyRoutineApp: App {
    @StateObject private var store = RoutineStore()
    @StateObject private var goalStore = GoalStore()

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem { Label("Routine", systemImage: "checklist") }
                GoalsView()
                    .tabItem { Label("Goals", systemImage: "target") }
            }
            .environmentObject(store)
            .environmentObject(goalStore)
        }
    }
}
