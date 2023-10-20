//
//  TrashTaskListView.swift
//  TaskManager
//
//  Created by 张鸿燊 on 3/10/2023.
//

import SwiftUI
import SwiftData

struct TrashTaskListView: View {
    
    @Query(
        filter: #Predicate<Task>{ $0.deletedAt != nil },
        sort:  \.deletedAt,
        order: .reverse
    )
    private var tasks: [Task]
    
    @State private var searchKeyword: String = ""
    @State private var selectedTasks: Set<Task> = Set()
    @State private var isExpanded: Bool = false
    @State private var showAlert: Bool = false
    
    @Environment(\.modelContext) private var context
    @Environment(\.openWindow) private var openWindow
    
    
    var body: some View {
        List(selection: $selectedTasks) {
            
            let unGroupedTasks = tasks.filter({$0.taskGroup == nil })
            ForEach(unGroupedTasks.filter({  search($0) }),
                    id: \.self) {task in
                TrashTaskView(task: task).tag(task)
            }
            
            let groupedTasks = Dictionary(grouping: tasks.filter({ $0.taskGroup != nil }), by: { $0.taskGroup })
            ForEach(groupedTasks.keys.compactMap({ $0 }), id: \.self) { taskGroup in
                Section {
                    ForEach(groupedTasks[taskGroup] ?? [] , id: \.self) { task in
                        TrashTaskView(task: task).tag(task)
                    }
                } header: {
                    Label(taskGroup.title, systemImage: "folder")
                        .contextMenu{
                            Button(LocalizedStringKey("contextMenu.restore")) {
                                let now = Date.now
                                (groupedTasks[taskGroup] ?? []).forEach{ task in
                                    task.deletedAt = now
                                }
                            }
                            Button(LocalizedStringKey("contextMenu.delete")) {
                                context.delete(taskGroup)
                            }
                            .keyboardShortcut(.delete, modifiers: [])
                        }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .searchable(text: $searchKeyword, placement: .toolbar)
        .navigationTitle(TaskSection.trash.name)
        .contextMenu(forSelectionType: Task.self) { tasks in
            if tasks.isEmpty {
            } else {
                Button(LocalizedStringKey("contextMenu.restore")) {
                    tasks.forEach{ task in
                        task.deletedAt = nil
                    }
                }
                Button(LocalizedStringKey("contextMenu.delete")) {
                    showAlert = true;
                    selectedTasks = Set(tasks)
                }
                .keyboardShortcut(.delete, modifiers: [])
            }
        } primaryAction: { tasks in
            for task in tasks {
                openWindow(value: task)
            }
        }
        .alert(LocalizedStringKey("alert.emptyTrash.title"),
               isPresented: $showAlert,
               actions: {
            Button(LocalizedStringKey("alert.button.cancel"), role: .cancel) {
                showAlert = false
            }
            Button(LocalizedStringKey("alert.button.delete"), role:.destructive) {
                showAlert = false
                selectedTasks.forEach{task in
                    context.delete(task)
                }
            }
        }, message: {
            Text(LocalizedStringKey("alert.emptyTrash.message"))
        })
        .toolbar {
            ToolbarItemGroup {
                if !tasks.isEmpty {
                    Button(LocalizedStringKey("toolbar.emptyTrash"), systemImage: "trash") {
                        showAlert = true;
                        selectedTasks = Set(tasks)
                    }
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
}


extension TrashTaskListView {
    
    struct TrashTaskView: View {
        
        @Bindable var task: Task
        @State var showAlert: Bool = false
        @Environment(\.modelContext) private var context
        
        var body: some View {
            HStack{
                Image(systemName: task.completed ? "largecircle.fill.circle":"circle")
                Text(task.title)
            }
            .draggable(task.id)
        }
    }
}


#Preview {
    TrashTaskListView()
}
