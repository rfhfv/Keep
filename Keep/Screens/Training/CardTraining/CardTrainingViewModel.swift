//
//  CardTrainingViewModel.swift
//  Keep
//
//  Created by admin on 18.11.2025.
//

import Foundation

protocol CardTrainingViewModelProtocol: AnyObject {
    var cards: [Card] { get }
    var currentIndex: Int { get }
    var isShowingFront: Bool { get }
    
    var currentCard: Card? { get }
    var progressText: String { get }
    var currentText: String { get }
    var currentLanguage: String { get }
    
    func flipCard()
    func nextCard()
    func speakCurrentText()
    var hasCards: Bool { get }
}

final class CardTrainingViewModel: CardTrainingViewModelProtocol {
    let cards: [Card]
    private(set) var currentIndex = 0
    private(set) var isShowingFront = true
    
    private let speechService: SpeechServiceProtocol
    
    init(cards: [Card], speechService: SpeechServiceProtocol = VoiceSpeechService()) {
        self.cards = cards
        self.speechService = speechService
    }
    
    var currentCard: Card? {
        guard cards.isEmpty == false, currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }
    
    var progressText: String {
        return "\(currentIndex + 1) из \(cards.count)"
    }
    
    var currentText: String {
        guard let card = currentCard else { return "" }
        return isShowingFront ? card.safeFrontText : card.safeBackText
    }
    
    var currentLanguage: String {
        guard let card = currentCard else { return "" }
        return isShowingFront ? card.safeSourceLanguage : card.safeTargetLanguage
    }
    
    func flipCard() {
        isShowingFront.toggle()
    }
    
    func nextCard() {
        currentIndex = (currentIndex + 1) % cards.count
        isShowingFront = true
    }
    
    func speakCurrentText() {
        guard let card = currentCard else { return }
        
        if isShowingFront {
            speechService.speakText(card.safeFrontText, language: card.safeSourceLanguage)
        } else {
            speechService.speakText(card.safeBackText, language: card.safeTargetLanguage)
        }
    }
    
    var hasCards: Bool {
        return cards.isEmpty == false
    }
}
