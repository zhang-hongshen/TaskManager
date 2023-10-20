//
//  FileMetaData.swift
//  TaskManager
//
//  Created by 张鸿燊 on 14/10/2023.
//

import Foundation
import UniformTypeIdentifiers

struct FileMetaData: Codable, Identifiable, Hashable {
    var id : String = UUID().uuidString
    var createdAt: Date = Date.now
    var modifiedAt: Date = Date.now
    var deletedAt: Date? = nil
    
    var data: Data = Data()
    var fileName: String = ""
    var type: UTType = .data
    
    init(data: Data = Data(), fileName: String = "", type: UTType = .data) {
        self.data = data
        self.fileName = fileName
        self.type = type
    }
    
}

extension FileMetaData: Equatable {
    static func == (lhs: FileMetaData, rhs: FileMetaData) -> Bool {
        return lhs.id == rhs.id
    }
}
