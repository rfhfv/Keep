//
//  View Protocols.swift
//  Keep
//
//  Created by admin on 20.11.2025.
//

import UIKit

protocol ThemeableView: AnyObject {
    func updateAppearance()
}

protocol SearchableView: AnyObject {
    func updateSearchAppearance()
}

protocol EmptyStateView: AnyObject {
    func updateEmptyState(isEmpty: Bool, isSearching: Bool)
}
