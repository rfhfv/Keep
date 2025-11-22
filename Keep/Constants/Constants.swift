//
//  Constants.swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import UIKit

enum Constants {
    enum Layout {
        static let defaultPadding: CGFloat = 16
        static let compactPadding: CGFloat = 12
        static let largePadding: CGFloat = 24
        static let smallPadding: CGFloat = 8
        static let extraLargePadding: CGFloat = 30
        
        static let cornerRadiusSmall: CGFloat = 12
        static let cornerRadius: CGFloat = 16
        static let cornerRadiusLarge: CGFloat = 20
        static let cornerRadiusExtraLarge: CGFloat = 25
        
        static let buttonSize: CGFloat = 44
        static let tabBarHeight: CGFloat = 100
        static let tableRowHeight: CGFloat = 70
        static let collectionCellWidth: CGFloat = 160
        static let collectionCellHeight: CGFloat = 140
        static let cardViewHeight: CGFloat = 450
        static let searchBarHeight: CGFloat = 50
        static let languageBadgeHeight: CGFloat = 16
        static let languageBadgeWidth: CGFloat = 30
    }
    
    enum Strings {
        static let collections = "Коллекции"
        static let training = "Тренировка"
        static let settings = "Настройки"
        static let searchPlaceholder = "Поиск"
        static let newCollection = "Новая коллекция"
        static let collectionsDidNotFound = "Коллекции не найдены"
        static let cardsDidNotFound = "Карточки не найдены"
        static let trainingCollectionsDidNotFound = "Коллекции для тренировки не найдены"
        static let emptyCollections = "У вас пока нет коллекций\nНажмите + чтобы создать первую"
        static let emptyTraining = "Нет коллекций для тренировки"
        static let emptyCards = "В этой коллекции пока нет карточек\nНажмите + чтобы добавить"
        static let collectionNamePlaceholder = "Название коллекции"
        static let flipCard = "Перевернуть"
        static let nextCard = "Следующая"
        static let appVersion = "Версия 1.0"
    }
    
    enum Images {
        static let collections = "circle.grid.2x2"
        static let training = "circle.grid.2x1"
        static let settings = "gearshape"
        static let plus = "plus"
        static let back = "chevron.left"
        static let speaker = "speaker.wave.2"
        static let speakerFill = "speaker.wave.2.fill"
        static let checkmark = "checkmark"
        static let arrowRight = "chevron.right"
    }
    
    enum Identifiers {
        static let collectionCell = "CollectionCell"
        static let trainingCell = "TrainingCollectionCell"
        static let cardCell = "CardCell"
        static let settingsCell = "Cell"
    }
    
    enum Animation {
        static let flipDuration: TimeInterval = 0.3
        static let buttonPressDuration: TimeInterval = 0.1
        static let audioTimeout: TimeInterval = 2.0
    }
}
