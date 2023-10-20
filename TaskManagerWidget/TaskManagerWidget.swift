//
//  TaskManagerWidget.swift
//  TaskManagerWidget
//
//  Created by 张鸿燊 on 3/10/2023.
//

import WidgetKit
import SwiftUI
import SwiftData


struct Provider: AppIntentTimelineProvider {
    
    @MainActor
    func placeholder(in context: Context) -> SimpleEntry {
        debugPrint("placeholder")
        return SimpleEntry(
            date: Date(),
            tasks: listTask(nil),
            configuration: ConfigurationAppIntent())
    }
    
    @MainActor
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        debugPrint("snapshot")
        return SimpleEntry(
            date: Date(),
            tasks: listTask(configuration.taskGroup.id),
            configuration: configuration)
    }
    
    
    @MainActor
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        debugPrint("timeline")
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(
            date: .now,
            tasks: listTask(configuration.taskGroup.taskGroupId),
            configuration: configuration)
        entries.append(entry)
        
        return Timeline(entries: entries, policy: .atEnd)
    }
    
    @MainActor
    func listTask(_ taskGroupId: String?) -> [Task] {
        let sortDescriptor = SortDescriptor<Task>(\.createdAt, order: .reverse)
        var predicate: Predicate<Task>
        if taskGroupId != nil {
            predicate = #Predicate<Task>{ $0.deletedAt == nil && !$0.completed && $0.taskGroup?.id == taskGroupId}
        } else {
            predicate = #Predicate<Task>{ $0.deletedAt == nil && !$0.completed }
        }
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: [sortDescriptor])
        descriptor.fetchLimit = 3
        guard let modelContainer = try? ModelContainer(for: Task.self) else {
            return []
        }
        
        let tasks = try? modelContainer.mainContext.fetch(descriptor)
        return tasks ?? []
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var tasks: [Task]
    let configuration: ConfigurationAppIntent
}

struct TaskManagerWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            if entry.tasks.isEmpty {
                Text(LocalizedStringKey("No Task"))
            } else {
                ForEach(entry.tasks){task in
                    HStack{
                        Button(intent: TaskIntent(taskId: task.id)){
                            Image(systemName: task.completed ? "largecircle.fill.circle" : "circle")
                        }
                        Text(task.title).lineLimit(1)
                        Spacer()
                    }
                }
            }
        }
        .padding()
    }
}

struct TaskManagerWidget: Widget {
    let kind: String = "TaskManagerWidget"

    var body: some WidgetConfiguration {
        
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            TaskManagerWidgetEntryView(entry: entry)
                .applySettings()
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for: [Task.self, TaskGroup.self])
        }
        .configurationDisplayName("configuration.displayName")
        .description("configuration.description")
        .supportedFamilies([.systemSmall, .systemMedium])
        
    }
}
