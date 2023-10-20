//
//  TaskGroup.swift
//  TaskManager
//
//  Created by 张鸿燊 on 1/10/2023.
//

import Foundation
import SwiftData

@Model
final class TaskGroup: Codable {
    @Attribute(.unique)
    var id : String = UUID().uuidString
    var createdAt: Date = Date.now
    var modifiedAt: Date = Date.now
    var deletedAt: Date? = nil
    
    var title: String = ""
    @Relationship(deleteRule: .cascade, inverse: \Task.taskGroup)
    var tasks: [Task] = []
    
    enum CodingKeys: CodingKey {
        case id, createdAt, modifiedAt, deletedAt
        case title, tasks
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.modifiedAt = try container.decode(Date.self, forKey: .modifiedAt)
        self.deletedAt = try container.decode(Date.self, forKey: .deletedAt)
        self.title = try container.decode(String.self, forKey: .title)
        self.tasks = try container.decode([Task].self, forKey: .tasks)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(modifiedAt, forKey: .modifiedAt)
        try container.encode(deletedAt, forKey: .deletedAt)
        try container.encode(title, forKey: .title)
        try container.encode(tasks, forKey: .tasks)
    }
    
    init(title: String = "", tasks: [Task] = []){
        self.title = title
    }
    
    static func example() -> TaskGroup {
        return TaskGroup(title: "New list 1")
    }
    
    static func examples() -> [TaskGroup] {
        return [
            TaskGroup(title: "New list 1"),
            TaskGroup(title: "New list 2"),
            TaskGroup(title: "New list 3")
        ]
    }
    
}

extension TaskGroup: Equatable {
    static func == (lhs: TaskGroup, rhs: TaskGroup) -> Bool {
        return lhs.id == rhs.id
    }
}
