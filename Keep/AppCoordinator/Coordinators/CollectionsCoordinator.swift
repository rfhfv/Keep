//
//  CollectionsCoordinator.swift
//  Keep
//
//  Created by admin on 14.11.2025.
//

import UIKit

protocol CollectionsCoordinatorProtocol: Coordinator {
    func showCollectionDetail(_ collection: CardCollection)
}

final class CollectionsCoordinator: CollectionsCoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showCollections()
    }
    
    private func showCollections() {
        let viewModel = CollectionsViewModel()
        let viewController = CollectionsViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showCollectionDetail(_ collection: CardCollection) {
        let viewModel = CollectionDetailViewModel(collection: collection)
        let viewController = CollectionDetailViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
