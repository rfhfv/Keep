//
//  ThemeType.swift
//  Keep
//
//  Created by admin on 22.11.2025.
//

import Foundation

enum ThemeType: String, CaseIterable {
    case light, dark
    
    var displayName: String {
        switch self {
        case .light: return "Светлая"
        case .dark: return "Тёмная"
        }
    }
}
