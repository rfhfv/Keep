//
//  CollectionsViewModel .swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import Foundation

protocol CollectionsViewModelProtocol: AnyObject {
    var collections: [CardCollection] { get }
    var filteredCollections: [CardCollection] { get }
    var isSearching: Bool { get }
    
    func loadCollections()
    func createCollection(name: String) -> CardCollection?
    func deleteCollection(_ collection: CardCollection)
    func filterCollections(with searchText: String)
    
    var shouldShowEmptyState: Bool { get }
    func getCollection(at index: Int) -> CardCollection?
    var collectionsCount: Int { get }
}

final class CollectionsViewModel: CollectionsViewModelProtocol {
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
        if isSearching == false {
            filteredCollections = collections
        }
    }
    
    func createCollection(name: String) -> CardCollection? {
        let uppercasedName = name.uppercased() 
        let collection = coreDataManager.createCollection(name: uppercasedName)
        loadCollections()
        return collection
    }
    
    func deleteCollection(_ collection: CardCollection) {
        coreDataManager.deleteCollection(collection)
        loadCollections()
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
    
    func getCollection(at index: Int) -> CardCollection? {
        let targetCollections = isSearching ? filteredCollections : collections
        guard index >= 0 && index < targetCollections.count else { return nil }
        return targetCollections[index]
    }
}
