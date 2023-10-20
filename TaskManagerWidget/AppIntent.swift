//
//  AppIntent.swift
//  TaskManagerWidget
//
//  Created by 张鸿燊 on 3/10/2023.
//

import WidgetKit
import AppIntents
import SwiftData
import SwiftUI

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("Task Group")
    static var description: IntentDescription? = ""
    
    @Parameter(title: LocalizedStringResource("configuration.parameter.taskGroup"))
    var taskGroup: TaskGroupAppEntity
}

struct TaskGroupAppEntity: AppEntity {
    var id: String = UUID().uuidString
    var taskGroupId: String?
    var title: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: LocalizedStringResource("configuration.parameter.taskGroup"))
    static var defaultQuery: TaskGroupQuery = TaskGroupQuery()
    
    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(stringLiteral: title)
    }
    
    init(taskGroupId: String? = nil, title: String) {
        self.taskGroupId = taskGroupId
        self.title = title
    }
}



struct TaskGroupQuery: EntityQuery {

    let defaultTaskGroup = TaskGroupAppEntity(taskGroupId: nil, title: "configuration.parameter.taskGroup.none")
    
    func taskGroupModelToAppEntity(_ models: [TaskGroup]) -> [TaskGroupAppEntity] {
        var entities : [TaskGroupAppEntity] = []
        for model in models {
            entities.append(TaskGroupAppEntity(taskGroupId: model.id, title: model.title))
        }
        return entities
    }
    
    @MainActor
    func listTaskGroup() -> [TaskGroup] {
        guard let container = try? ModelContainer(for: TaskGroup.self) else {
            return []
        }
        let predicate = #Predicate<TaskGroup>{ $0.deletedAt == nil }
        let taskGroups = try? container.mainContext.fetch(FetchDescriptor(predicate: predicate))
        return taskGroups ?? []
    }
    
    @MainActor
    func entities(for identifiers: [TaskGroupAppEntity.ID]) async throws -> [TaskGroupAppEntity] {
        let filterdTaskGroups = listTaskGroup().filter {
            identifiers.contains($0.id)
        }
        var entities : [TaskGroupAppEntity] = [defaultTaskGroup]
        entities.append(contentsOf: taskGroupModelToAppEntity(filterdTaskGroups))
        
        return entities
    }
    
    @MainActor
    func suggestedEntities() async throws -> [TaskGroupAppEntity] {
        let taskGroups = listTaskGroup()
        var entities : [TaskGroupAppEntity] = [defaultTaskGroup]
        entities.append(contentsOf: taskGroupModelToAppEntity(taskGroups))
        return entities
    }
    
    func defaultResult() async -> TaskGroupAppEntity? {
        debugPrint("defaultResult")
        return defaultTaskGroup
    }
    
}

struct TaskIntent: AppIntent {
    init() {
        self.taskId = ""
    }
    
    static var title: LocalizedStringResource = "Task Group"
    static var description: IntentDescription? = ""
    
    @Parameter(title: "Task Id")
    var taskId: String
    
    
    init(taskId: String) {
        self.taskId = taskId
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        guard let container = try? ModelContainer(for: Task.self) else {
            return .result()
        }
        let predicate = #Predicate<Task>{ $0.id == taskId }
        let task = try? container.mainContext.fetch(FetchDescriptor(predicate: predicate))
        withAnimation{
            if let task = task?.first {
                task.completed = true
            }
        }
        return .result()
    }
}
