//
//  Date+.swift
//  TaskManager
//
//  Created by 张鸿燊 on 10/10/2023.
//

import Foundation

extension Date {
    func toDataComponents() -> DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
    }
    
}
