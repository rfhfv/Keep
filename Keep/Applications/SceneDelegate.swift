//
//  SceneDelegate.swift
//  Keep
//
//  Created by admin on 12.11.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var coordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        ThemeManager.shared.applyTheme()
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        coordinator = AppCoordinator(navigationController: navigationController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        coordinator?.start()
    }
}
