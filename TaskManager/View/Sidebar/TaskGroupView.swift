//
//  TaskGroupView.swift
//  TaskManager
//
//  Created by 张鸿燊 on 7/10/2023.
//

import SwiftUI
import SwiftData

struct TaskGroupView: View {
    
    @Bindable var group : TaskGroup
    @State private var alertIsShown: Bool = false
    @Environment(\.modelContext) private var context
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        HStack {
            Image(systemName: TaskSection.group(group).icon)
            TextField(LocalizedStringKey("New Group"), text: $group.title)
        }
        .tag(TaskSection.group(group))
        .alert(LocalizedStringKey("alert.deleteGroup.title_\(group.title)"), isPresented: $alertIsShown, actions: {
            Button(LocalizedStringKey("alert.button.cancel"), role:.cancel) {
                alertIsShown = false
            }
            Button(LocalizedStringKey("alert.button.delete"), role:.destructive) {
                alertIsShown = false
                TaskGroupRepository.softDelete(group)
                TaskRepository.batchSoftDelete(group.tasks)
            }
        }, message: {
            Text(LocalizedStringKey("alert.deleteGroup.message"))
        })
        .contextMenu{
            Button(LocalizedStringKey("contextMenu.delete")) {
                alertIsShown = true
            }
            .keyboardShortcut(.delete, modifiers: [])
            Button(LocalizedStringKey("contextMenu.showGroupInfo")){
                openWindow(value: group)
            }
            .keyboardShortcut(.space, modifiers: [])
        }
    }
    
    func DropPerform(taskIds: [String], section: TaskSection) -> Bool {
        DispatchQueue.main.async {
            let tasks = try? context.fetch(FetchDescriptor<Task>(predicate: #Predicate<Task>{ taskIds.contains($0.id)}))
            (tasks ?? []).forEach{ task in
                switch section {
                case .all:
                    task.deletedAt = nil;
                case .completed:
                    task.deletedAt = nil;
                    task.completed = true;
                    
                case .trash:
                    if(task.deletedAt == nil) {
                        task.deletedAt = .now
                    }
                case .group(let taskGroup):
                    task.deletedAt = nil;
                    task.taskGroup = taskGroup;
                }
            }
        }
        return true
    }
}

#Preview {
    TaskGroupView(group: TaskGroup())
}
