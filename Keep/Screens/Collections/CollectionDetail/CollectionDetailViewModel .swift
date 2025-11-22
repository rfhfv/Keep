//
//  CollectionDetailViewModel .swift
//  Keep
//
//  Created by admin on 15.11.2025.
//

import Foundation

protocol CollectionDetailViewModelProtocol: AnyObject {
    var collection: CardCollection { get }
    var cards: [Card] { get }
    var filteredCards: [Card] { get }
    var isSearching: Bool { get }
    
    func loadCards()
    func addManualCard(frontText: String, backText: String, source: String, target: String) -> Card
    func deleteCard(_ card: Card)
    func filterCards(with searchText: String)
    func speakText(_ text: String, language: String)
    
    var shouldShowEmptyState: Bool { get }
    func getCard(at index: Int) -> Card?
    var cardsCount: Int { get }
}

final class CollectionDetailViewModel: CollectionDetailViewModelProtocol {
    let collection: CardCollection
    private(set) var cards: [Card] = []
    private(set) var filteredCards: [Card] = []
    private(set) var isSearching = false
    
    private let coreDataManager: CoreDataManager
    private let speechService: SpeechServiceProtocol
    
    init(collection: CardCollection,
         coreDataManager: CoreDataManager = .shared,
         speechService: SpeechServiceProtocol = VoiceSpeechService()) {
        self.collection = collection
        self.coreDataManager = coreDataManager
        self.speechService = speechService
        loadCards()
    }
    
    func loadCards() {
        cards = coreDataManager.fetchCards(for: collection)
        if isSearching == false {
            filteredCards = cards
        }
    }
    
    func addManualCard(frontText: String, backText: String, source: String, target: String) -> Card {
        let formattedFrontText = frontText.capitalized
        let formattedBackText = backText.capitalized
        
        let card = coreDataManager.createCardManually(
            frontText: formattedFrontText,
            backText: formattedBackText,
            collection: collection,
            sourceLanguage: source,
            targetLanguage: target
        )
        loadCards()
        return card
    }
    
    func deleteCard(_ card: Card) {
        coreDataManager.deleteCard(card)
        loadCards()
    }
    
    func filterCards(with searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredCards = cards
        } else {
            isSearching = true
            filteredCards = cards.filter { card in
                let frontContains = card.safeFrontText.lowercased().contains(searchText.lowercased())
                let backContains = card.safeBackText.lowercased().contains(searchText.lowercased())
                return frontContains || backContains
            }
        }
    }
    
    func speakText(_ text: String, language: String) {
        speechService.speakText(text, language: language)
    }
    
    var shouldShowEmptyState: Bool {
        if isSearching {
            return filteredCards.isEmpty
        } else {
            return cards.isEmpty
        }
    }
    
    func getCard(at index: Int) -> Card? {
        let targetCards = isSearching ? filteredCards : cards
        guard index >= 0 && index < targetCards.count else { return nil }
        return targetCards[index]
    }
    
    var cardsCount: Int {
        return isSearching ? filteredCards.count : cards.count
    }
}
