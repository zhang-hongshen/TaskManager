//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by 张鸿燊 on 1/10/2023.
//

import SwiftUI
import SwiftData

@main
struct TaskManagerApp: App {
    
    @AppStorage(UserDefaults.Key.trash.rawValue)
    private var trash = UserDefaults.Trash.never
    @AppStorage(UserDefaults.Key.showInMenuBar.rawValue)
    private var showInMenuBar: Bool = true
    
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Task.self, TaskGroup.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .applySettings()
        }
        .modelContainer(modelContainer)
        
        #if os(macOS)
        Settings{
            SettingsView()
                .applySettings()
        }
        
        MenuBarExtra(isInserted: $showInMenuBar) {
            MenuBarView()
                .applySettings()
                .modelContainer(modelContainer)
            
        } label: {
            Label("Task Manager",systemImage: "square.and.pencil")
        }
        .modelContainer(modelContainer)
        .menuBarExtraStyle(.window)
        
        WindowGroup(for: Task.self) { $task in
            if let task = task {
                TaskDetailView(task: task)
                    .navigationTitle(Text(LocalizedStringKey("window.taskInfo.title_\(task.title)")))
                    .applySettings()
                    
            }
        }
        .modelContainer(modelContainer)
        
        WindowGroup(for: TaskGroup.self) { $taskGroup in
            if let taskGroup = taskGroup {
                TaskGroupDetailView(taskGroup: taskGroup)
                    .navigationTitle(Text(LocalizedStringKey("window.taskGroupInfo.title_\(taskGroup.title)")))
                    .applySettings()
                    
            }
        }
        .modelContainer(modelContainer)
        #endif
        
        
    }
}
