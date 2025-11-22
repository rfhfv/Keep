//
//  CardCollection.swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import CoreData

@objc(CardCollection)
public class CardCollection: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        if name == nil { name = "Новая коллекция" }
    }
}

extension CardCollection {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardCollection> {
        return NSFetchRequest<CardCollection>(entityName: "CardCollection")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var cards: NSSet?
}

extension CardCollection {
    var safeName: String { return name ?? "Без названия" }
    
    var cardsArray: [Card] {
        let set = cards as? Set<Card> ?? []
        return Array(set)
    }
}
