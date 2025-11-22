//
//  Card.swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import CoreData

@objc(Card)
public class Card: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        if frontText == nil { frontText = "" }
        if backText == nil { backText = "" }
        if sourceLanguage == nil { sourceLanguage = "en" }
        if targetLanguage == nil { targetLanguage = "ru" }
    }
}

extension Card {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }
    
    @NSManaged public var frontText: String?
    @NSManaged public var backText: String?
    @NSManaged public var sourceLanguage: String?
    @NSManaged public var targetLanguage: String?
    @NSManaged public var collection: CardCollection?
}

extension Card {
    var safeFrontText: String { return frontText ?? "" }
    var safeBackText: String { return backText ?? "" }
    var safeSourceLanguage: String { return sourceLanguage ?? "en" }
    var safeTargetLanguage: String { return targetLanguage ?? "ru" }
}
