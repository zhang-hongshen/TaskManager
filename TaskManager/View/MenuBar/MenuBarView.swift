//
//  MenuBarView.swift
//  TaskManager
//
//  Created by 张鸿燊 on 2/10/2023.
//

import SwiftUI
import SwiftData

struct MenuBarView: View {
    
    @Query(
        filter: #Predicate<TaskGroup>{ $0.deletedAt == nil }
    ) private var taskGroups: [TaskGroup]
    
    @ObservedObject private var viewModel = MenubarViewModel()
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                TextField(LocalizedStringKey("task.title"), text: $viewModel.title)
                    .font(.title2)
                    .textFieldStyle(.plain)
                Divider()
                
                Picker(selection: $viewModel.taskGroup) {
                    Text(LocalizedStringKey("taskgroup.none")).tag(nil as TaskGroup?)
                    ForEach(taskGroups) { group in
                        Text(group.title).tag(group as TaskGroup?)
                    }
                } label: {
                    Text(LocalizedStringKey("task.group"))
                }
                .font(.headline)
                
                DueDateView(hasDueDate: $viewModel.hasDueDate, 
                            dueDate: $viewModel.dueDate)
                
                if viewModel.hasDueDate {
                    NotificationView(notified: $viewModel.notified,
                                     timeInterval: $viewModel.notificationTimeInterval)
                }
                
            }
            HStack {
                Button(LocalizedStringKey("Save")) {
                    let newTask = viewModel.newTask()
                    context.insert(newTask)
                    TaskNotificationManager.shared.sendCanlendarNotification(task: newTask)
                    viewModel.resetForm()
                }
                .padding()
                .font(.title2)
            }
            
        }
        .padding()
    }
}

extension MenuBarView {
    struct DueDateView: View {
        @Binding var hasDueDate: Bool
        @Binding var dueDate: Date?
        
        var body: some View {
            Toggle(isOn: $hasDueDate){
                HStack {
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey("task.dueDate"))
                            .font(.headline)
                        if hasDueDate {
                            DatePicker("",
                                       selection: Binding(get: {dueDate ?? .now }, set: { dueDate = $0 }))
                            .foregroundStyle(dueDate != nil && dueDate! < Date.now ? .red : .primary)
                            .datePickerStyle(.compact)
                            
                        }
                    }
                }
                
            }
            #if os(macOS)
            .toggleStyle(.checkbox)
            #elseif os(iOS)
            .toggleStyle(.switch)
            #endif
        }
    }
}

extension MenuBarView {
    
    struct NotificationView: View {
        
        @Binding var notified: Bool
        @Binding var timeInterval: Task.NotificationTimeInterval
        
        var body: some View {
            Toggle(isOn: $notified) {
                HStack {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(LocalizedStringKey("task.notified"))
                            .font(.headline)
                        if notified {
                            HStack(spacing: 5) {
                                TextField("", value: $timeInterval.value, formatter: NumberFormatter())
                                    .textFieldStyle(.roundedBorder)
                                Picker("", selection: $timeInterval.unit) {
                                    ForEach(TimeUnit.allCases()){ unit in
                                        Text(unit.name).tag(unit)
                                    }
                                }
                                Picker("", selection: $timeInterval.position) {
                                    ForEach(TimePosition.allCases()){ position in
                                        Text(position.name).tag(position)
                                    }
                                }
                            }
                            .font(.subheadline)
                        }
                    }
                }
            }
            #if os(macOS)
            .toggleStyle(.checkbox)
            #elseif os(iOS)
            .toggleStyle(.switch)
            #endif
        }
    }
}

#Preview {
    MenuBarView()
}
