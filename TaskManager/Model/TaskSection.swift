//
//  TaskSection.swift
//  TaskManager
//
//  Created by 张鸿燊 on 1/10/2023.
//

import Foundation
import SwiftUI

enum TaskSection: Identifiable, Hashable {
    case all
    case completed
    case trash
    case group(TaskGroup)
    
    var id: String {
        switch self {
        case .all:
            return "All"
        case .completed:
            return "Completed"
        case .trash:
            return "Trash"
        case .group(let taskGroup):
            return taskGroup.id
        }
    }
    
    var name: LocalizedStringKey {
        switch self {
        case .all:
            return LocalizedStringKey("tasksection.all")
        case .completed:
            return LocalizedStringKey("tasksection.completed")
        case .trash:
            return LocalizedStringKey("tasksection.trash")
        case .group(let taskGroup):
            return LocalizedStringKey(taskGroup.title)
        }
    }
    
    var icon: String {
        switch self {
        case .all:
            return "star"
        case .completed:
            return "checkmark.circle"
        case .trash:
            return "trash"
        case .group:
            return "folder"
        }
    }
    
    static func allCases() -> [TaskSection] {
        return [.all, .completed, .trash]
    }
    
}
