//
//  Tasj'.swift
//  TaskManager
//
//  Created by 张鸿燊 on 1/10/2023.
//

import Foundation
import UniformTypeIdentifiers
import SwiftData
import SwiftUI


@Model
final class Task: Codable {
    
    struct NotificationTimeInterval: Codable, Equatable {
        var value: Int = 1
        var unit: TimeUnit = .day
        var position: TimePosition = .before
        
        init(value: Int = 1, unit: TimeUnit = .day, position: TimePosition = .before) {
            self.value = value
            self.unit = unit
            self.position = position
        }
    }
    
    @Attribute(.unique)
    var id : String = UUID().uuidString
    var createdAt: Date = Date.now
    var modifiedAt: Date = Date.now
    var deletedAt: Date? = nil
    
    var title: String =  ""
    var remark: String = ""
    var completed: Bool = false
    var taskGroup: TaskGroup? = nil
    var hasDueDate: Bool = false
    var dueDate: Date? = Date.now

    var notified: Bool = false
    /// Description
    var notificationTimeInterval: NotificationTimeInterval = NotificationTimeInterval()
    var images: [FileMetaData] = []
    
    
    enum CodingKeys: CodingKey {
        case id, createdAt, modifiedAt, deletedAt
        case title, remark, completed, taskGroup, hasDueDate, dueDate, notified, notificationTimeInterval, images
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.modifiedAt = try container.decode(Date.self, forKey: .modifiedAt)
        self.deletedAt = try container.decode(Date.self, forKey: .deletedAt)
        self.title = try container.decode(String.self, forKey: .title)
        self.remark = try container.decode(String.self, forKey: .remark)
        self.completed = try container.decode(Bool.self, forKey: .completed)
        self.taskGroup = try container.decode(TaskGroup.self, forKey: .taskGroup)
        self.hasDueDate = try container.decode(Bool.self, forKey: .hasDueDate)
        self.dueDate = try container.decode(Date.self, forKey: .dueDate)
        self.notified = try container.decode(Bool.self, forKey: .notified)
        self.notificationTimeInterval = try container.decode(NotificationTimeInterval.self, forKey: .notificationTimeInterval)
        self.images = try container.decode([FileMetaData].self, forKey: .images)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(modifiedAt, forKey: .modifiedAt)
        try container.encode(deletedAt, forKey: .deletedAt)
        try container.encode(title, forKey: .title)
        try container.encode(remark, forKey: .remark)
        try container.encode(completed, forKey: .completed)
        try container.encode(taskGroup, forKey: .taskGroup)
        try container.encode(hasDueDate, forKey: .hasDueDate)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(notified, forKey: .notified)
        try container.encode(notificationTimeInterval, forKey: .notificationTimeInterval)
        try container.encode(images, forKey: .images)
    }
    
    init(title: String = "", remark: String = "", hasDueDate: Bool = false, dueDate: Date? = .now, completed: Bool = false, taskGroup: TaskGroup? = nil, notified: Bool = false, notificationTimeInterval: NotificationTimeInterval = NotificationTimeInterval(), images: [FileMetaData] = []){
        self.title = title
        self.remark = remark
        self.completed = completed
        self.taskGroup = taskGroup
        self.hasDueDate = hasDueDate
        self.dueDate = dueDate
        self.notified = notified
        self.notificationTimeInterval = notificationTimeInterval
        self.images = images
    }
    
    
    
    func markCompleted() {
        self.deletedAt = nil
        self.completed = true
    }
}

extension Task: Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Task {
    static func example() -> Task {
        return Task(title: "Buy milk")
    }
    
    static func examples() -> [Task] {
        return [
            Task(title: "Buy milk"),
            Task(title: "Eat Food", completed: true),
            Task(title: "Drink", completed: false)
        ]
    }
}
