//
//  TaskGroupRepository.swift
//  TaskManager
//
//  Created by 张鸿燊 on 3/10/2023.
//

import Foundation
import SwiftData

class TaskGroupRepository {
    
    @MainActor
    static func softDelete(_ model: TaskGroup) {
        model.deletedAt = .now
    }
    
    @MainActor
    static func batchSoftDelete(_ models: [TaskGroup]) {
        models.forEach{ model in
            model.deletedAt = .now
        }
    }
}
