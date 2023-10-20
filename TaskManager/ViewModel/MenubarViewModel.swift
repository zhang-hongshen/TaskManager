//
//  MenubarViewModel.swift
//  TaskManager
//
//  Created by 张鸿燊 on 10/10/2023.
//

import Foundation


class MenubarViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var taskGroup: TaskGroup? = nil
    @Published var hasDueDate: Bool = false
    @Published var dueDate: Date? = .now
    @Published var notified: Bool = false
    @Published var notificationTimeInterval: Task.NotificationTimeInterval = Task.NotificationTimeInterval()
    
    
    func resetForm() {
        title = ""
        taskGroup = nil
        hasDueDate = false
        dueDate = Date.now
        notified = false
        notificationTimeInterval = Task.NotificationTimeInterval()
    }
    
    func newTask() -> Task {
        return Task(
            title: title,
            hasDueDate: hasDueDate,
            dueDate: dueDate,
            taskGroup: taskGroup,
            notified: notified,
            notificationTimeInterval: notificationTimeInterval
        )
    }
}
