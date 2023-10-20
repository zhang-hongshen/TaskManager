//
//  NotificationUnit.swift
//  TaskManager
//
//  Created by 张鸿燊 on 10/10/2023.
//

import Foundation
import SwiftUI

enum TimePosition: Identifiable, Codable {
    case before, after
    
    static func allCases() -> [TimePosition] {
        return [.before, .after]
    }
    
    var id: String {
        switch self {
        case .before:
            return "Before"
        case .after:
            return "After"
        }
    }
    
    var name: LocalizedStringKey {
        switch self {
        case .before:
            return "timeposition.before"
        case .after:
            return "timeposition.after"
        }
    }
}

enum TimeUnit: Identifiable, Codable {
    case second, minute, hour, day, month, year
    
    static func allCases() -> [TimeUnit] {
        return [.second, .minute, .hour, .day, .month, .year]
    }
    
    func toCalendarComponent() -> Calendar.Component {
        switch self {
        case .second:
            return .second
        case .minute:
            return .minute
        case .hour:
            return .hour
        case .day:
            return .day
        case .month:
            return .month
        case .year:
            return .year
        }
    }
    
    var id: String {
        switch self {
        case .second:
            return "Second"
        case .minute:
            return "Minute"
        case .hour:
            return "Hour"
        case .day:
            return "Day"
        case .month:
            return "Month"
        case .year:
            return "Year"
        }
    }
    
    var name: LocalizedStringKey {
        switch self {
        case .second:
            return "timeunit.second"
        case .minute:
            return "timeunit.minute"
        case .hour:
            return "timeunit.hour"
        case .day:
            return "timeunit.day"
        case .month:
            return "timeunit.month"
        case .year:
            return "timeunit.year"
        }
    }
    
}

