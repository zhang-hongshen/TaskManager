//
//  DateFormatter.swift
//  TaskManager
//
//  Created by 张鸿燊 on 16/10/2023.
//

import Foundation


extension DateFormatter {
    static func defaultLocaleFormat(template: String) -> String? {
        return DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: Locale.defaultLocale)
    }
}
