//
//  MainTabBarController.swift
//  Keep
//
//  Created by admin on 12.11.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private var blurView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        setupThemeObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let tabBarHeight: CGFloat = 100
        tabBar.frame = CGRect(
            x: 0,
            y: view.frame.height - tabBarHeight,
            width: view.frame.width,
            height: tabBarHeight
        )
        updateBlurViewFrame()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private Methods

private extension MainTabBarController {
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.isTranslucent = true
        updateTabBarAppearance()
    }
    
    func updateTabBarAppearance() {
        if ThemeManager.shared.currentTheme == .dark {
            tabBar.tintColor = .ypWhite
            tabBar.unselectedItemTintColor = .ypLightGray
        } else {
            tabBar.tintColor = .ypDarkGray
            tabBar.unselectedItemTintColor = .ypDarkGray
        }
        updateGlassBackground()
    }
    
    func updateGlassBackground() {
        blurView?.removeFromSuperview()
        
        let isDark = ThemeManager.shared.currentTheme == .dark
        let blurStyle: UIBlurEffect.Style = isDark ? .systemUltraThinMaterialDark : .systemUltraThinMaterialLight
        let newBlurView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        
        let tintColor = isDark ? UIColor.ypBlack.withAlphaComponent(0.2) : UIColor.ypWhite.withAlphaComponent(0.3)
        let tintView = UIView()
        tintView.backgroundColor = tintColor
        tintView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        newBlurView.contentView.addSubview(tintView)
        tintView.frame = newBlurView.bounds
        
        newBlurView.layer.cornerRadius = 25
        newBlurView.layer.masksToBounds = true
        newBlurView.layer.borderWidth = isDark ? 0 : 0.5
        newBlurView.layer.borderColor = isDark ? nil : UIColor.ypLightGray.cgColor
        
        view.insertSubview(newBlurView, belowSubview: tabBar)
        blurView = newBlurView
        updateBlurViewFrame()
        
        tintView.frame = newBlurView.bounds
    }
    
    func updateBlurViewFrame() {
        blurView?.frame = CGRect(
            x: 0,
            y: tabBar.frame.origin.y,
            width: view.frame.width,
            height: tabBar.frame.height
        )
    }
    
    func setupThemeObserver() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("ThemeDidChange"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateTabBarAppearance()
        }
    }
}
