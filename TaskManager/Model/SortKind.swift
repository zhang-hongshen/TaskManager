//
//  SortKind.swift
//  TaskManager
//
//  Created by 张鸿燊 on 7/10/2023.
//

import Foundation
import SwiftUI

enum SortDirection: Identifiable {
    case ascending, descending
    
    static func allCases() -> [SortDirection] {
        return [.ascending, .descending]
    }
    
    var id : String {
        switch self {
        case .ascending:
            return UUID().uuidString
        case .descending:
            return UUID().uuidString
        }
    }
    
    var name: LocalizedStringKey {
        switch self {
        case .ascending:
            return LocalizedStringKey("toolbar.sortBy.ascending")
        case .descending:
            return LocalizedStringKey("toolbar.sortBy.descending")
        }
    }
}

enum TaskSortKind: Identifiable {
    case title, createdAt
    
    static func allCases() -> [TaskSortKind] {
        return [.title, createdAt]
    }
    
    var id : String {
        switch self {
        case .title:
            return UUID().uuidString
        case .createdAt:
            return UUID().uuidString
        }
    }
    
    var name: LocalizedStringKey {
        switch self {
        case .title:
            return LocalizedStringKey("toolbar.sortBy.title")
        case .createdAt:
            return LocalizedStringKey("toolbar.sortBy.createdAt")
        }
    }
}
