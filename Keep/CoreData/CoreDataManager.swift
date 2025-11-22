//
//  CoreDataManager.swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CardsModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Ошибка CoreData: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
    
    // MARK: - Collection Methods
    
    func createCollection(name: String) -> CardCollection {
        let collection = CardCollection(context: context)
        collection.name = name
        
        saveContext()
        return collection
    }
    
    func fetchCollections() -> [CardCollection] {
        let request: NSFetchRequest<CardCollection> = CardCollection.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка извлечения коллекций: \(error)")
            return []
        }
    }
    
    func deleteCollection(_ collection: CardCollection) {
        context.delete(collection)
        saveContext()
    }
    
    func createCardManually(frontText: String, backText: String, collection: CardCollection, sourceLanguage: String = "en", targetLanguage: String = "ru") -> Card {
        let card = Card(context: context)
        card.frontText = frontText
        card.backText = backText
        card.sourceLanguage = sourceLanguage
        card.targetLanguage = targetLanguage
        card.collection = collection
        
        saveContext()
        return card
    }
    
    func fetchCards(for collection: CardCollection) -> [Card] {
        return collection.cardsArray
    }
    
    func deleteCard(_ card: Card) {
        context.delete(card)
        saveContext()
    }
}
