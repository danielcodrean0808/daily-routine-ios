import Combine
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: RoutineStore
    @Environment(\.scenePhase) private var scenePhase
    @State private var newTitle = ""

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("New task", text: $newTitle)
                            .onSubmit(addTask)
                        Button("Add", action: addTask)
                            .disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }

                Section("Today: \(store.doneCount) of \(store.tasks.count) done") {
                    if store.tasks.isEmpty {
                        Text("No tasks yet. Add one above to start your routine.")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(store.tasks) { task in
                        Button {
                            store.toggle(task)
                        } label: {
                            HStack {
                                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(task.isDone ? .green : .secondary)
                                Text(task.title)
                                    .strikethrough(task.isDone)
                                    .foregroundStyle(task.isDone ? .secondary : .primary)
                            }
                        }
                    }
                    .onDelete(perform: store.delete)
                    .onMove(perform: store.move)
                }
            }
            .navigationTitle("Daily Routine")
            .toolbar {
                EditButton()
            }
            .onChange(of: scenePhase) { _, phase in
                if phase == .active {
                    store.resetIfNewDay()
                }
            }
            // scenePhase only changes when the app is opened or closed, so also
            // clear the ticks at midnight if the app is left open on screen.
            .onReceive(
                NotificationCenter.default
                    .publisher(for: .NSCalendarDayChanged)
                    .receive(on: DispatchQueue.main)
            ) { _ in
                store.resetIfNewDay()
            }
        }
    }

    private func addTask() {
        store.add(newTitle)
        newTitle = ""
    }
}

#Preview {
    ContentView()
        .environmentObject(RoutineStore())
}
