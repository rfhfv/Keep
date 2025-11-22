//
//  TrainingCoordinator.swift
//  Keep
//
//  Created by admin on 14.11.2025.
//

import UIKit

protocol TrainingCoordinatorProtocol: Coordinator {
    func showCardTraining(with cards: [Card])
}

final class TrainingCoordinator: TrainingCoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showTraining()
    }
    
    private func showTraining() {
        let viewModel = TrainingViewModel()
        let viewController = TrainingViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showCardTraining(with cards: [Card]) {
        let viewModel = CardTrainingViewModel(cards: cards)
        let viewController = CardTrainingViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
