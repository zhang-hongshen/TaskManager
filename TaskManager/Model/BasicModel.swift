//
//  BasicModel.swift
//  TaskManager
//
//  Created by 张鸿燊 on 6/10/2023.
//

import Foundation
import SwiftData


struct BasicModel {
    var id : String = UUID().uuidString
    var createTime: Date = Date.now
    
    var deleted: Bool = false
    var deleteTime: Date? = nil
    
    init(id: String, createTime: Date, deleted: Bool, deleteTime: Date? = nil) {
        self.id = id
        self.createTime = createTime
        self.deleted = deleted
        self.deleteTime = deleteTime
    }
}
