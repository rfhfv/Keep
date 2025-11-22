//
//  AppCoordinator.swift
//  Keep
//
//  Created by admin on 12.11.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

protocol AppCoordinatorProtocol: Coordinator {
    func showMainTabBar()
}

final class AppCoordinator: AppCoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMainTabBar()
    }
    
    func showMainTabBar() {
        let tabBarController = MainTabBarController()
        
        let collectionsNav = UINavigationController()
        let collectionsCoordinator: CollectionsCoordinatorProtocol = CollectionsCoordinator(navigationController: collectionsNav)
        
        let trainingNav = UINavigationController()
        let trainingCoordinator: TrainingCoordinatorProtocol = TrainingCoordinator(navigationController: trainingNav)
        
        let settingsNav = UINavigationController()
        let settingsCoordinator: SettingsCoordinatorProtocol = SettingsCoordinator(navigationController: settingsNav)
        
        collectionsNav.tabBarItem = UITabBarItem(
            title: Constants.Strings.collections,
            image: UIImage(systemName: Constants.Images.collections),
            selectedImage: UIImage(systemName: Constants.Images.collections)
        )
        
        trainingNav.tabBarItem = UITabBarItem(
            title: Constants.Strings.training,
            image: UIImage(systemName: Constants.Images.training),
            selectedImage: UIImage(systemName: Constants.Images.training)
        )
        
        settingsNav.tabBarItem = UITabBarItem(
            title: Constants.Strings.settings,
            image: UIImage(systemName: Constants.Images.settings),
            selectedImage: UIImage(systemName: Constants.Images.settings)
        )
        
        tabBarController.viewControllers = [collectionsNav, trainingNav, settingsNav]
        navigationController.setViewControllers([tabBarController], animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
        
        collectionsCoordinator.start()
        trainingCoordinator.start()
        settingsCoordinator.start()
    }
}
