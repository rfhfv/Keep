//
//  TrainingViewModel .swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import Foundation

protocol TrainingViewModelProtocol: AnyObject {
    var collections: [CardCollection] { get }
    var filteredCollections: [CardCollection] { get }
    var isSearching: Bool { get }
    
    func loadCollections()
    func filterCollections(with searchText: String)
    func getCards(for collection: CardCollection) -> [Card]
    
    var shouldShowEmptyState: Bool { get }
    func getCollection(at index: Int) -> CardCollection?
    var collectionsCount: Int { get }
}

final class TrainingViewModel: TrainingViewModelProtocol {
    private(set) var collections: [CardCollection] = []
    private(set) var filteredCollections: [CardCollection] = []
    private(set) var isSearching = false
    
    private let coreDataManager: CoreDataManager
    
    var shouldShowEmptyState: Bool {
        if isSearching {
            return filteredCollections.isEmpty
        } else {
            return collections.isEmpty
        }
    }
    
    var collectionsCount: Int {
        return isSearching ? filteredCollections.count : collections.count
    }
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
        loadCollections()
    }
    
    func loadCollections() {
        collections = coreDataManager.fetchCollections()
        if isSearching == false{
            filteredCollections = collections
        }
    }
    
    func filterCollections(with searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredCollections = collections
        } else {
            isSearching = true
            filteredCollections = collections.filter {
                $0.safeName.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func getCards(for collection: CardCollection) -> [Card] {
        return coreDataManager.fetchCards(for: collection)
    }
    
    func getCollection(at index: Int) -> CardCollection? {
        let targetCollections = isSearching ? filteredCollections : collections
        guard index >= 0 && index < targetCollections.count else { return nil }
        return targetCollections[index]
    }
}
