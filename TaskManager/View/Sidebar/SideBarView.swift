//
//  SideBarView.swift
//  TaskManager
//
//  Created by 张鸿燊 on 1/10/2023.
//

import SwiftUI
import SwiftData



struct SideBarView: View {
    
    @Query(
        filter: #Predicate<TaskGroup>{ $0.deletedAt == nil},
        sort: \.createdAt,
        order: .reverse)
    private var taskGroups: [TaskGroup]
    @Binding var selection: TaskSection?
    
    @Environment(\.modelContext) private var context

    var body: some View {
        List(selection: $selection){
            ForEach(TaskSection.allCases()) { section in
                Label(section.name, systemImage: section.icon).tag(section)
                    .dropDestination { items, location in
                        withAnimation {
                            return DropPerform(taskIds: items, section: section)
                        }
                        
                    }
            }
            Section(LocalizedStringKey("sidebar.yourGroups")) {
                ForEach(taskGroups) { group in
                    TaskGroupView(group: group).tag(TaskSection.group(group))
                        .dropDestination { items, location in
                            withAnimation {
                                return DropPerform(taskIds: items, section: TaskSection.group(group))
                            }
                        }
                }
            }
            
            Button(LocalizedStringKey("sidebar.yourGroups.newGroup"), systemImage: "plus.circle") {
                let newGroup = TaskGroup(title: "")
                context.insert(newGroup)
            }
            .buttonStyle(.borderless)
        }
        .font(.title3)
    }
    
    func DropPerform(taskIds: [String], section: TaskSection) -> Bool {
        DispatchQueue.main.async {
            let tasks = try? context.fetch(FetchDescriptor<Task>(predicate: #Predicate<Task>{ taskIds.contains($0.id) }))
            (tasks ?? []).forEach{ task in
                
                switch section {
                case .all:
                    task.deletedAt = nil;
                case .completed:
                    task.markCompleted()
                case .trash:
                    if(task.deletedAt == nil) {
                        task.deletedAt = .now
                    }
                case .group(let taskGroup):
                    task.deletedAt = nil
                    task.taskGroup = taskGroup
                }
            }
        }
        return true
    }
}

struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView(selection: .constant(.all))
    }
}
