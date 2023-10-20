//
//  Settings.swift
//  TaskManager
//
//  Created by 张鸿燊 on 2/10/2023.
//

import Foundation

enum LanguageSetting {
    static let supportedLanguages: [String: String] = [
        
        Locale.LanguageCode.english.identifier : "English",
        "es": "Español",
        Locale.LanguageCode.french.identifier: "Français",
        "de": "Deutsch",
        Locale.LanguageCode.italian.identifier: "Italiano",
        Locale.LanguageCode.japanese.identifier: "日本語",
        Locale.LanguageCode.korean.identifier: "한국어",
        "zh-Hans" : "简体中文",
        "zh-Hant": "繁體中文",
        "ar": "العربية",
        Locale.LanguageCode.russian.identifier : "Русский",
        "hi": "हिन्दी",
        Locale.LanguageCode.portuguese.identifier: "Português",
        "nl": "Nederlands",
        "sv": "Svenska",
    ]
    
    static let defaultLanguage: String = "en"
    
}
