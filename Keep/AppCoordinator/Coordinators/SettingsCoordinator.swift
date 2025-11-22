//
//  SettingsCoordinator.swift
//  Keep
//
//  Created by admin on 14.11.2025.
//

import UIKit

protocol SettingsCoordinatorProtocol: Coordinator { }

final class SettingsCoordinator: SettingsCoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSettings()
    }
    
    private func showSettings() {
        let viewModel = SettingsViewModel()
        let viewController = SettingsViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(viewController, animated: false)
    }
}
