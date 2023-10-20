//
//  UserDefaults.swift
//  TaskManager
//
//  Created by 张鸿燊 on 2/10/2023.
//

import Foundation


extension UserDefaults {
    enum Key: String {
        case appearance = "appearance"
        case language = "language"
        case sync = "sync"
        case trash = "trash"
        case showInMenuBar = "showInMenuBar"
    }
    
    enum Appearance: String {
        case syncWithSystem = "syncWithSystem"
        case light = "light"
        case dark = "dark"
    }
    
    enum Sync: String {
        case none = "None"
        case iCloud = "iCloud"
    }
    
    enum Trash: String {
        case never = "Never"
        case after10days = "After10days"
        case after30days = "After30days"
    }
}
