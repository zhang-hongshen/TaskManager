//
//  TaskRepository.swift
//  TaskManager
//
//  Created by 张鸿燊 on 3/10/2023.
//

import Foundation
import SwiftData

class TaskRepository {

    @MainActor
    static func softDelete(_ model: Task) {
        model.deletedAt = .now
    }
    
    @MainActor
    static func batchSoftDelete(_ models: [Task]) {
        models.forEach{ model in
            model.deletedAt = .now
        }
    }
    
    @MainActor
    static func batchSoftDelete(_ models: Set<Task>) {
        models.forEach{ model in
            model.deletedAt = .now
        }
    }
}
