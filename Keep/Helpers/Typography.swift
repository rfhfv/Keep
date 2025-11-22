//
//  Typography.swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import UIKit

enum Typography {
    case titleLabel
    case collectionName
    case cardsCount
    case emptyState
    case frontLabel
    case backLabel
    case languageBadge
    case titleDetail
    case cardLabel
    case cardLanguageLabel
    case progressLabel
    
    var font: UIFont {
        switch self {
        case .titleLabel:
            return .systemFont(ofSize: 34, weight: .bold)
        case .collectionName:
            return .systemFont(ofSize: 16, weight: .semibold)
        case .cardsCount:
            return .systemFont(ofSize: 12, weight: .regular)
        case .emptyState:
            return .systemFont(ofSize: 16, weight: .semibold)
        case .frontLabel:
            return .systemFont(ofSize: 16, weight: .bold)
        case .backLabel:
            return .systemFont(ofSize: 14)
        case .languageBadge:
            return .systemFont(ofSize: 10, weight: .medium)
        case .titleDetail:
            return .systemFont(ofSize: 24, weight: .bold)
        case .cardLabel:
            return .systemFont(ofSize: 36, weight: .bold)
        case .cardLanguageLabel:
            return .systemFont(ofSize: 18, weight: .medium)
        case .progressLabel:
            return .systemFont(ofSize: 14)
        }
        
    }
}
