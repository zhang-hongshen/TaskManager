//
//  Locale.swift
//  TaskManager
//
//  Created by 张鸿燊 on 6/10/2023.
//

import Foundation

extension Locale {
    static var defaultLocale = Locale(identifier: 
                                        Bundle.main.preferredLocalizations.first ??
                                      Locale.preferredLanguages.first != nil && LanguageSetting.supportedLanguages.keys.contains(Locale.preferredLanguages.first!) ?
                                      Locale.preferredLanguages.first! : LanguageSetting.defaultLanguage)
}
