//
//  TaskDetailView.swift
//  TaskManager
//
//  Created by 张鸿燊 on 2/10/2023.
//

import SwiftUI
import SwiftData
import PhotosUI

struct TaskDetailView: View {
    
    @Bindable var task: Task
    @Query(
        filter: #Predicate<TaskGroup>{ $0.deletedAt == nil},
        sort: \.createdAt,
        order: .reverse
    )
    private var taskGroups: [TaskGroup]
    @Environment(\.modelContext) private var context
    @FocusState private var focusState: FocusText?
    
    enum FocusText {
        case title
        case remark
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10){
                TextField(LocalizedStringKey("task.title"), text: $task.title)
                    .font(.title2)
                    .textFieldStyle(.plain)
                    .focused($focusState, equals: .title)
                    .onSubmit {
                        focusState = .remark
                    }
                
                Divider()
                
                TextField(LocalizedStringKey("task.remark"), text: $task.remark)
                    .font(.title2)
                    .textFieldStyle(.plain)
                    .focused($focusState, equals: .remark)
                    .onSubmit {
                        focusState = nil
                    }
                Divider()
                
                Picker(selection: $task.taskGroup) {
                    Text(LocalizedStringKey("taskgroup.none")).tag(nil as TaskGroup?)
                    
                    ForEach(taskGroups) { group in
                        Text(group.title).tag(group as TaskGroup?)
                    }
                } label: {
                    Text(LocalizedStringKey("task.group"))
                }
                .font(.headline)
                #if os(iOS)
                .pickerStyle(.navigationLink)
                #endif
                
                DueDateView(task: task)
                if task.hasDueDate {
                    NotificationView(task: task)
                }
                ImagesView(task: task)
            }
            Spacer()
        }
        .padding()
    }
}

extension TaskDetailView {
    
    struct DueDateView: View{
        @Bindable var task: Task
        
        var body: some View {
            VStack(alignment: .leading) {
                Toggle(isOn: $task.hasDueDate){
                    Text(LocalizedStringKey("task.dueDate"))
                        .font(.headline)
                }
                #if os(macOS)
                .toggleStyle(.checkbox)
                #elseif os(iOS)
                .toggleStyle(.switch)
                #endif
                if task.hasDueDate {
                    DatePicker("",
                               selection: Binding(get: {task.dueDate ?? .now }, set: { task.dueDate = $0 }))
                    .foregroundStyle(task.dueDate != nil && task.dueDate! < Date.now ? .red : .primary)
                    .datePickerStyle(.compact)
                }
            }
        }
    }
    
    
}

extension TaskDetailView {
    
    struct NotificationView: View{
        @Bindable var task: Task
        
        var body: some View {
            VStack(alignment: .leading) {
                Toggle(isOn: $task.notified) {
                    Text(LocalizedStringKey("task.notified"))
                        .font(.headline)
                }
                #if os(macOS)
                .toggleStyle(.checkbox)
                #elseif os(iOS)
                .toggleStyle(.switch)
                #endif

                if task.notified {
                    HStack(spacing: 5) {
                        TextField("", value: $task.notificationTimeInterval.value, formatter: NumberFormatter())
                            .textFieldStyle(.roundedBorder)
                        Picker("", selection: $task.notificationTimeInterval.unit) {
                            ForEach(TimeUnit.allCases()){ unit in
                                Text(unit.name).tag(unit)
                            }
                        }
                        Picker("", selection: $task.notificationTimeInterval.position) {
                            ForEach(TimePosition.allCases()){ position in
                                Text(position.name).tag(position)
                            }
                        }
                        Spacer()
                    }
                    .font(.subheadline)
                }
            }
            .onChange(of: task.notificationTimeInterval, { oldValue, newValue in
                TaskNotificationManager.shared.sendCanlendarNotification(task: task)
            })
        }
        
    }
}

extension TaskDetailView {
    struct ImagesView: View {
        @Bindable var task: Task
        @State private var selectedImages: Set<FileMetaData> = Set()
        
        var body: some View {
            HStack(alignment: .top) {
                #if os(macOS)
                VStack {
                    Text(LocalizedStringKey("task.images"))
                        .font(.headline)
                }
                GridPhotosPicker(images: $task.images, column: 4, spacing: 10)
                #elseif os(iOS)
                GridPhotosPicker(images: $task.images, column: 2, spacing: 5)
                #endif
            }
        }
    }
}

#Preview {
    TaskDetailView(task: .example())
}
