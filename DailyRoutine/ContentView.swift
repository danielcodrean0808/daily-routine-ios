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
                            .disabled(newTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }

                Section("Today: \(store.doneCount) of \(store.tasks.count) done") {
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
