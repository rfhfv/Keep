//
//  ThemeManager.swift
//  Keep
//
//  Created by admin on 19.11.2025.
//

import UIKit

protocol Theme {
    var gradientColors: [CGColor] { get }
    var gradientLocations: [NSNumber] { get }
    var gradientStartPoint: CGPoint { get }
    var gradientEndPoint: CGPoint { get }
    var blurStyle: UIBlurEffect.Style { get }
    var tintColor: UIColor { get }
    var glassBorderColor: CGColor? { get }
    var glassBorderWidth: CGFloat { get }
    var userInterfaceStyle: UIUserInterfaceStyle { get }
}

final class ThemeManager {
    static let shared = ThemeManager()
    
    private let themeKey = "selectedTheme"
    private var currentThemeInstance: Theme = DarkTheme()
    
    var currentTheme: ThemeType {
        get {
            if let saved = UserDefaults.standard.string(forKey: themeKey),
               let themeType = ThemeType(rawValue: saved) {
                return themeType
            }
            return .dark
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: themeKey)
            currentThemeInstance = newValue == .light ? LightTheme() : DarkTheme()
            applyTheme()
        }
    }
    
    private init() {
        currentThemeInstance = currentTheme == .light ? LightTheme() : DarkTheme()
    }
    
    private func getCurrentTheme() -> Theme {
        return currentThemeInstance
    }
    
    func backgroundGradient() -> CAGradientLayer {
        let theme = getCurrentTheme()
        let gradient = CAGradientLayer()
        
        gradient.colors = theme.gradientColors
        gradient.locations = theme.gradientLocations
        gradient.startPoint = theme.gradientStartPoint
        gradient.endPoint = theme.gradientEndPoint
        
        return gradient
    }
    
    func glassEffect() -> UIVisualEffectView {
        let theme = getCurrentTheme()
        let blurEffect = UIBlurEffect(style: theme.blurStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        let tintView = UIView()
        tintView.backgroundColor = theme.tintColor
        
        blurView.contentView.addSubview(tintView)
        tintView.frame = blurView.bounds
        tintView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return blurView
    }
    
    func glassBorderColor() -> CGColor? {
        return getCurrentTheme().glassBorderColor
    }
    
    func glassBorderWidth() -> CGFloat {
        return getCurrentTheme().glassBorderWidth
    }
    
    func applyTheme() {
        let theme = getCurrentTheme()
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = theme.userInterfaceStyle
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("ThemeDidChange"), object: nil)
    }
}
