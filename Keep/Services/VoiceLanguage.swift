//
//  VoiceLanguage.swift
//  Keep
//
//  Created by admin on 22.11.2025.
//

import Foundation

enum VoiceLanguage: String {
    case english = "en-us"
    case russian = "ru-ru"
    case german = "de-de"
    
    static func fromLanguageCode(_ code: String) -> VoiceLanguage {
        switch code {
        case "ru": return .russian
        case "de": return .german
        default: return .english
        }
    }
}
