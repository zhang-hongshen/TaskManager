//
//  SettingsDetailView.swift
//  TaskManager
//
//  Created by 张鸿燊 on 2/10/2023.
//

import Foundation
import SwiftUI


struct SettingsView: View {
    
    @AppStorage(UserDefaults.Key.appearance.rawValue)
    private var appearance = UserDefaults.Appearance.syncWithSystem
    @AppStorage(UserDefaults.Key.language.rawValue)
    private var language : String = Locale.defaultLocale.identifier
    @AppStorage(UserDefaults.Key.sync.rawValue)
    private var sync = UserDefaults.Sync.none
    @AppStorage(UserDefaults.Key.trash.rawValue)
    private var trash = UserDefaults.Trash.never
    @AppStorage(UserDefaults.Key.showInMenuBar.rawValue)
    private var showInMenuBar: Bool = true
    
    
    var body: some View {
        VStack(alignment: .leading) {
            List{
                Toggle(LocalizedStringKey("settings.showInMenuBar"), isOn: $showInMenuBar)
                    #if os(macOS)
                    .toggleStyle(.checkbox)
                    #elseif os(iOS)
                    .toggleStyle(.switch)
                    #endif
                Picker(LocalizedStringKey("settings.appearance"), selection: $appearance) {
                    Text(LocalizedStringKey("settings.appearance.syncWithSystem")).tag(UserDefaults.Appearance.syncWithSystem)
                    Text(LocalizedStringKey("settings.appearance.light")).tag(UserDefaults.Appearance.light)
                    Text(LocalizedStringKey("settings.appearance.dark")).tag(UserDefaults.Appearance.dark)
                }
                #if os(macOS)
                .pickerStyle(.radioGroup)
                #elseif os(iOS)
                .pickerStyle(.navigationLink)
                
                #endif
                Picker(LocalizedStringKey("settings.language"), selection: $language) {
                    ForEach(Bundle.main.localizations.sorted(), id:\.self) {localization in
                        if let language = LanguageSetting.supportedLanguages[localization] {
                            Text(language).tag(localization)
                        }
                    }
                }
                #if os(iOS)
                .pickerStyle(.navigationLink)
                #endif
                
                Picker(LocalizedStringKey("settings.sync"), selection: $sync) {
                    Text(LocalizedStringKey("settings.sync.none")).tag(UserDefaults.Sync.none)
                    Text(LocalizedStringKey("settings.sync.iCloud")).tag(UserDefaults.Sync.iCloud)
                }
                #if os(macOS)
                .pickerStyle(.radioGroup)
                #endif
                
                Picker(LocalizedStringKey("settings.trash"), selection: $trash) {
                    Text(LocalizedStringKey("settings.trash.never")).tag(UserDefaults.Trash.never)
                    Text(LocalizedStringKey("settings.trash.after_\(10)_days")).tag(UserDefaults.Trash.after10days)
                    Text(LocalizedStringKey("settings.trash.after_\(30)_days")).tag(UserDefaults.Trash.after30days)
                }
                
            }
            
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
