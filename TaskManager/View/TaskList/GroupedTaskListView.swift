//
//  TaskList.swift
//  TaskManager
//
//  Created by 张鸿燊 on 1/10/2023.
//

import SwiftUI
import SwiftData

struct GroupedTaskListView: View {
    
    @Bindable var taskGroup: TaskGroup
    
    @State private var searchKeyword: String = ""
    @State private var selectedTasks: Set<Task> = Set()
    // toolbar
    @State private var sortBy: TaskSortKind = .createdAt
    
    @Environment(\.modelContext) private var context
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        List(selection: $selectedTasks) {
            ForEach(taskGroup.tasks.filter({ search($0) }), id: \.self) { task in
                TaskView(task: task).tag(task)
            }
        }
        .navigationTitle(taskGroup.title)
        .searchable(text: $searchKeyword, placement: .toolbar)
        .contextMenu(forSelectionType: Task.self) { tasks in
            if tasks.isEmpty {
                Button(LocalizedStringKey("contextMenu.newTask")) {
                    newTask()
                }
                .keyboardShortcut(.delete, modifiers: [])
                Button(LocalizedStringKey("contextMenu.showGroupInfo")){
                    openWindow(value: taskGroup)
                }
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
                Menu {
                    Picker(selection: $sortBy, label: Text(LocalizedStringKey("toolbar.sortBy"))) {
                        Section {
                            ForEach(TaskSortKind.allCases()) { sortKind in
                                Text(sortKind.name).tag(sortKind)
                            }
                        }
                        Section {
                            ForEach(SortDirection.allCases()) { direction in
                                Text(direction.name).tag(direction)
                            }
                        }
                    }
                    Button(LocalizedStringKey("contextMenu.showGroupInfo")){
                        openWindow(value: taskGroup)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
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
        let newTask = Task(taskGroup: taskGroup)
        context.insert(newTask)
    }
}

struct GroupedTaskListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupedTaskListView(taskGroup: TaskGroup())
    }
}
