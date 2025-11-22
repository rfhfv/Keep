//
//  SettingsViewModel.swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import Foundation

protocol SettingsViewModelProtocol: AnyObject {
    var themes: [ThemeType] { get }
    var themeNames: [String] { get }
    var currentTheme: ThemeType { get }
    var appVersion: String { get }
    
    func setTheme(_ theme: ThemeType)
    func themeName(at index: Int) -> String
    func theme(at index: Int) -> ThemeType?
    var themesCount: Int { get }
}

final class SettingsViewModel: SettingsViewModelProtocol {
    let themes: [ThemeType] = [.light, .dark]
    let themeNames: [String] = ["Светлая", "Темная"]
    
    var currentTheme: ThemeType {
        return ThemeManager.shared.currentTheme
    }
    
    var appVersion: String {
        return Constants.Strings.appVersion
    }
    
    func setTheme(_ theme: ThemeType) {
        ThemeManager.shared.currentTheme = theme
    }
    
    func themeName(at index: Int) -> String {
        guard index >= 0 && index < themeNames.count else { return "" }
        return themeNames[index]
    }
    
    func theme(at index: Int) -> ThemeType? {
        guard index >= 0 && index < themes.count else { return nil }
        return themes[index]
    }
    
    var themesCount: Int {
        return themes.count
    }
}
