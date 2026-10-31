import SwiftUI

struct GoalsView: View {
    @EnvironmentObject var goalStore: GoalStore
    @State var showAddGoal = false
    @State var selectedGoal: LifeGoal?
    @State var filterCategory: LifeGoal.GoalCategory?
    
    var filteredGoals: [LifeGoal] {
        if let category = filterCategory {
            return goalStore.sortedGoals.filter { $0.category == category }
        }
        return goalStore.sortedGoals
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if goalStore.goals.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "target")
                            .font(.system(size: 60))
                            .foregroundColor(.purple)
                        
                        Text("No Goals Yet")
                            .font(.headline)
                        
                        Text("Create a life goal to inspire yourself")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Button(action: { showAddGoal = true }) {
                            Label("Add Goal", systemImage: "plus.circle.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                } else {
                    VStack {
                        // Category filter
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                Button(action: { filterCategory = nil }) {
                                    Text("All")
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(filterCategory == nil ? Color.purple : Color.gray.opacity(0.2))
                                        .foregroundColor(filterCategory == nil ? .white : .primary)
                                        .cornerRadius(6)
                                }
                                
                                ForEach(LifeGoal.GoalCategory.allCases, id: \.self) { category in
                                    Button(action: { filterCategory = category }) {
                                        Text(category.rawValue.capitalized)
                                            .font(.subheadline)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(filterCategory == category ? Color.purple : Color.gray.opacity(0.2))
                                            .foregroundColor(filterCategory == category ? .white : .primary)
                                            .cornerRadius(6)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 8)
                        
                        // Goals list
                        List {
                            ForEach(filteredGoals) { goal in
                                GoalRow(goal: goal)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedGoal = goal
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            goalStore.deleteGoal(goal.id)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                }
            }
            .navigationTitle("Life Goals")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showAddGoal = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showAddGoal) {
                AddLifeGoalView()
                    .environmentObject(goalStore)
            }
            .sheet(item: $selectedGoal) { goal in
                EditLifeGoalView(goal: goal)
                    .environmentObject(goalStore)
            }
        }
    }
}

struct GoalRow: View {
    let goal: LifeGoal
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(goal.title)
                        .font(.headline)
                    
                    Text(goal.priority.rawValue.uppercased())
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red.opacity(goal.priority == .critical ? 0.3 : 0.1))
                        .foregroundColor(goal.priority == .critical ? .red : .orange)
                        .cornerRadius(4)
                }
                
                Text(goal.category.rawValue.capitalized)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                if let description = goal.description, !description.isEmpty {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                CircularProgressView(progress: goal.progress)
                    .frame(width: 50, height: 50)
                
                if let targetDate = goal.targetDate, targetDate > Date() {
                    Text("\(Calendar.current.dateComponents([.day], from: Date(), to: targetDate).day ?? 0)d")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 3)
            
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 100) / 100)
                .stroke(Color.purple, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            VStack(spacing: 2) {
                Text("\(Int(progress))%")
                    .font(.caption2)
                    .fontWeight(.bold)
            }
        }
    }
}

struct AddLifeGoalView: View {
    @EnvironmentObject var goalStore: GoalStore
    @Environment(\.dismiss) var dismiss
    
    @State var title = ""
    @State var description = ""
    @State var category: LifeGoal.GoalCategory = .personal
    @State var priority: LifeGoal.Priority = .medium
    @State var targetDate: Date? = nil
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Goal Details") {
                    TextField("Goal title", text: $title)
                    
                    TextField("Description (optional)", text: $description)
                    
                    Picker("Category", selection: $category) {
                        ForEach(LifeGoal.GoalCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue.capitalized).tag(cat)
                        }
                    }
                    
                    Picker("Priority", selection: $priority) {
                        Text("Low").tag(LifeGoal.Priority.low)
                        Text("Medium").tag(LifeGoal.Priority.medium)
                        Text("High").tag(LifeGoal.Priority.high)
                        Text("Critical").tag(LifeGoal.Priority.critical)
                    }
                    
                    Toggle("Set target date?", isOn: Binding(
                        get: { targetDate != nil },
                        set: { if $0 { targetDate = Date() } else { targetDate = nil } }
                    ))
                    
                    if targetDate != nil {
                        DatePicker("Target date", selection: Binding(get: { targetDate ?? Date() }, set: { targetDate = $0 }), displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Add Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        var goal = LifeGoal(title: title, category: category, priority: priority)
                        goal.description = description.isEmpty ? nil : description
                        goal.targetDate = targetDate
                        goalStore.addGoal(goal)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

struct EditLifeGoalView: View {
    @EnvironmentObject var goalStore: GoalStore
    @Environment(\.dismiss) var dismiss
    
    @State var goal: LifeGoal
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Goal Details") {
                    TextField("Title", text: $goal.title)
                    
                    TextField("Description", text: Binding(get: { goal.description ?? "" }, set: { goal.description = $0.isEmpty ? nil : $0 }))
                    
                    Picker("Category", selection: $goal.category) {
                        ForEach(LifeGoal.GoalCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue.capitalized).tag(cat)
                        }
                    }
                    
                    Picker("Priority", selection: $goal.priority) {
                        Text("Low").tag(LifeGoal.Priority.low)
                        Text("Medium").tag(LifeGoal.Priority.medium)
                        Text("High").tag(LifeGoal.Priority.high)
                        Text("Critical").tag(LifeGoal.Priority.critical)
                    }
                }
                
                Section("Progress") {
                    Slider(value: $goal.progress, in: 0...100, step: 5)
                    Text("\(Int(goal.progress))% complete")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Section("Timeline") {
                    if goal.targetDate != nil {
                        DatePicker("Target Date", selection: Binding(get: { goal.targetDate ?? Date() }, set: { goal.targetDate = $0 }), displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Edit Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        goalStore.updateGoal(goal)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    GoalsView()
        .environmentObject(GoalStore())
}
