//
//  View+.swift
//  TaskManager
//
//  Created by 张鸿燊 on 2/10/2023.
//

import Foundation
import SwiftUI


struct SettingsModifier: ViewModifier {
    
    @AppStorage(UserDefaults.Key.appearance.rawValue)
    private var apperance = UserDefaults.Appearance.syncWithSystem
    
    @AppStorage(UserDefaults.Key.language.rawValue)
    private var language : String = Locale.defaultLocale.identifier
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme({
                switch apperance {
                case .syncWithSystem:
                    return nil
                case .light:
                    return .light
                case .dark:
                    return .dark
                }
            }())
            .environment(\.locale, .init(identifier: language))
            
    }
}

extension View {
    func applySettings() -> some View {
            self.modifier(SettingsModifier())
    }
}
