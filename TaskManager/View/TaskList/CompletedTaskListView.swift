//
//  DoneTaskListView.swift
//  TaskManager
//
//  Created by 张鸿燊 on 6/10/2023.
//

import SwiftUI
import SwiftData

struct CompletedTaskListView: View {
    @Query(
        filter: #Predicate<Task>{ $0.deletedAt == nil && $0.completed },
        sort: \.createdAt,
        order: .reverse)
    private var tasks: [Task]
    
    @State private var searchKeyword: String = ""
    @State private var selectedTasks: Set<Task> = Set()
    
    @Environment(\.modelContext) private var context
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        List(selection: $selectedTasks) {
            let unGroupedTasks = tasks.filter({$0.taskGroup == nil })
            ForEach(unGroupedTasks.filter({ search($0) }), id: \.self) { task in
                TaskView(task: task).tag(task)
            }
            let groupedTasks = Dictionary(grouping: tasks.filter({ $0.taskGroup != nil }), by: { $0.taskGroup })
            ForEach(groupedTasks.keys.compactMap({ $0 }), id: \.self) { taskGroup in
                Section {
                    ForEach(groupedTasks[taskGroup] ?? [] , id: \.self) { task in
                        TaskView(task: task).tag(task)
                    }
                } header: {
                    Label(taskGroup.title, systemImage: "folder")
                }
            }
        }
        .navigationTitle(Text(TaskSection.completed.name))
        .searchable(text: $searchKeyword, placement: .toolbar)
        .contextMenu(forSelectionType: Task.self) { tasks in
            if tasks.isEmpty {
                Button(LocalizedStringKey("contextMenu.newTask")) {
                    newTask()
                }
                .keyboardShortcut(.delete, modifiers: [])
            } else {
                Button(LocalizedStringKey("contextMenu.delete")) {
                    TaskRepository.batchSoftDelete(tasks)
                }
                .keyboardShortcut(.delete, modifiers: [])
                Button(LocalizedStringKey("contextMenu.showTaskInfo")) {
                    for task in tasks {
                        openWindow(value: task)
                    }
                }
                .keyboardShortcut(.space, modifiers: [])
            }
        }
        .toolbar {
            ToolbarItemGroup {
                Button(LocalizedStringKey("toolbar.newTask"), systemImage: "square.and.pencil") {
                    newTask()
                }
            }
        }
    }
    
    func search(_ task: Task) -> Bool {
        if searchKeyword.isEmpty {
            return true
        }
        return task.title.localizedCaseInsensitiveContains(searchKeyword)
    }
    
    func newTask() {
        let newTask = Task(completed: true, taskGroup: nil)
        context.insert(newTask)
    }
}

#Preview {
    CompletedTaskListView()
}
